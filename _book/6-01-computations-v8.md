# (PART) JavaScript for Computations {-}

# The V8 Engine {#v8}

V8 is an R interface to Google's open-source JavaScript engine of the same name; it powers Google Chrome, node.js and many other things. It is the last integration of JavaScript with R that is covered in this book. Both the V8 package and the engine it wraps are straightforward yet amazingly powerful.

## Installation {#v8-installation}

First, install the V8 engine itself, instructions to do so are well detailed on [V8's README](https://github.com/jeroen/v8#installation) and below.

On Debian or Ubuntu use the code below from the terminal to install [libv8](https://v8.dev/).

```bash
sudo apt-get install -y libv8-dev
```

On Centos install v8-devel, which requires the EPEL tools.

```bash
sudo yum install epel-release
sudo yum install v8-devel
```

On Mac OS use [Homebrew](https://brew.sh/).

```bash
brew install v8
```

Then install the R package from CRAN.

```r
install.packages("V8")
```

## Basics {#v8-basics}

V8 provides a reference class provided via the [R6](https://github.com/r-lib/R6) [@R-R6] package; this pertains to object-oriented programming; hence it might look unconventional to many R users. It's nonetheless easy to grasp. If one wants to learn more about the R6's reference class system, Hadley Wickham has an outstanding chapter on it in his [Advanced R](https://adv-r.hadley.nz/r6.html) book.

Let us explore the basic functionalities of the package. First, load the library and use the function `v8` to instantiate a class; this effectively returns an execution environment, every such environment is independent of another.


```r
library(V8)
#> Using V8 engine 6.8.275.32-node.55

engine <- v8()
```

The `eval` method allows running JavaScript code from R.


```r
engine$eval("var x = 3 + 4;") # this is evaluated in R
engine$eval("x")
#> [1] "7"
```

Two observations worth making on the above snippet of code. First, the variable we got back in R is a character vector when it should have been either an integer or a numeric. This is because we used the `eval` method, which returns what is printed in the v8 console, `get` is more appropriate; it converts the output to its appropriate R equivalent.


```r
# retrieve the previously created variable
(x <- engine$get("x"))
#> [1] 7
class(x)
#> [1] "integer"
```

Second, while creating a scalar with `eval("var x = 1;")` appears painless, imagine if you will the horror of having to convert a data frame to a JavaScript array via jsonlite then flatten it to character string so it can be used with the `eval` method. Horrid. Thankfully V8 comes with a method `assign`, complimentary to `get`,  which declares R objects as JavaScript variables. It takes two arguments, first the name of the variable to create, second the object to assign to it.


```r
# assign and retrieve a data.frame
engine$assign("vehicles", cars[1:3, ])
engine$get("vehicles")
#>   speed dist
#> 1     4    2
#> 2     4   10
#> 3     7    4
```

All of the conversion is handled by V8 internally with jsonlite, as demonstrated in the previous chapter. We can confirm that the data frame was converted to a list row-wise; using `JSON.stringify` to display how the object is stored in V8.


```r
cat(engine$eval("JSON.stringify(vehicles, null, 2);"))
#> [
#>   {
#>     "speed": 4,
#>     "dist": 2
#>   },
#>   {
#>     "speed": 4,
#>     "dist": 10
#>   },
#>   {
#>     "speed": 7,
#>     "dist": 4
#>   }
#> ]
```

However this reveals a tedious cyclical loop: 1) creating an object in JavaScript to 2) run a function on the aforementioned object 3) get the results back in R, and repeat. So V8 also allows calling JavaScript functions on R objects directly with the `call` method and obtain the results back in R. 


```r
engine$eval("new Date();") # using eval
#> [1] "Sun Oct 18 2020 18:36:52 GMT+0200 (Central European Summer Time)"
engine$call("Date", Sys.Date()) # using call
#> [1] "Sun Oct 18 2020 18:36:52 GMT+0200 (Central European Summer Time)"
```

Finally, one can run code interactively rather than as strings by calling the console from the engine with `engine$console()` you can then exit the console by typing `exit` or hitting the <kbd>ESC</kbd> key.

## External Libraries {#v8-external}

V8 is quite bare in and of itself; there is, for instance, no functionalities built-in to read or write files from disk, it thus becomes truly interesting when you can use it JavaScript libraries. We'll demonstrate this using [fuse.js](https://fusejs.io/) a fuzzy-search library. 

The very first step of integrating any external library is to look at the code, often examples, to grasp an idea of what is to be achieved from R. Below is an example from the official documentation. First, an array of two `books` is defined; this is later used to test the search. Then another array of options is defined, this should at the very least include the key(s) that should be searched, here it is set to search through the title and authors. Then, the fuse object is initialised based on the array of books and the options. Finally, the `search` method is used to retrieve all books, the title or author of which, partially match the term `tion`.

```js
// books to search through
var books = [{
  'ISBN': 'A',
  'title': "Old Man's War",
  'author': 'John Scalzi'
}, {
  'ISBN': 'B',
  'title': 'The Lock Artist',
  'author': 'Steve Hamilton'
}]

const options = {
  // Search in `author` and in `title` array
  keys: ['author', 'title']
}

// initialise
const fuse = new Fuse(books, options)

// search 'tion' in authors and titles
const result = fuse.search('tion')
```

With some understanding of what is to be reproduced in R, we can import the library with the `source` method which takes a `file` argument that will accept a path or URL to a JavaScript file to source, below we use the handy CDN (Content Delivery Network) to avoid downloading a file.


```r
uri <- paste0(
  "https://cdnjs.cloudflare.com/ajax/",
  "libs/fuse.js/3.4.6/fuse.min.js"
)
engine$source(uri)
#> [1] "true"
```

You can think of it as using the `script` tag in HTML to source (`src`) said file from disk or CDN.

```html
<html>
  <head>
    <script 
      src='https://cdnjs.cloudflare.com/.../fuse.min.js'>
    </script>
  </head>
  <body>
  </body>
</html>
```

Now onto replicating the array (list) which we want to search through, the `books` object used in a previous example. As already observed, this is in essence, how V8 stores data frames in the environment. Below we define a data frame of books that looks similar and load it into the engine.


```r
books <- data.frame(
  title = c(
    "Rights of Man",
    "Black Swan",
    "Common Sense",
    "Sense and Sensibility"
  ),
  id = c("a", "b", "c", "d")
)

engine$assign("books", books)
```

Then again, we can make sure that the data frame was turned into a row-wise JSON object.


```r
cat(engine$eval("JSON.stringify(books, null, 2);"))
#> [
#>   {
#>     "title": "Rights of Man",
#>     "id": "a"
#>   },
#>   {
#>     "title": "Black Swan",
#>     "id": "b"
#>   },
#>   {
#>     "title": "Common Sense",
#>     "id": "c"
#>   },
#>   {
#>     "title": "Sense and Sensibility",
#>     "id": "d"
#>   }
#> ]
```

Now we can define options for the search; we don't get into the details of fuse.js here as this is not the purpose of this book, you can read more about the options in the [examples section](https://fusejs.io/#Examples) of the site. We can mimic the format of the JSON options shown on the website with a simple list and assign that to a new variable in the engine. Note that we wrap the title in a `list` to ensure it is converted to an array of length 1: `list("title")` should be converted to a `["title"]` array and not a `"title"` scalar.

```js
// JavaScript
var options = {
  keys: ['title'],
  id: 'id'
}
```


```r
# R
options <- list(
  keys = list("title"),
  id = "id"
)

engine$assign("options", options)
```

Then we can finish the second step of the online examples, instantiate a fuse.js object with the books and options objects, then do a search, the result of which is assigned to an object which is retrieved in R with `get`.


```r
engine$eval("var fuse = new Fuse(books, options)")
engine$eval("var results = fuse.search('sense')")
engine$get("results")
#> [1] "d" "c"
```

A search for "sense" returns a vector of ids where the term "sense" was found; `c` and `d` or the books Common Sense, Sense and Sensibility. We could perhaps make that last code simpler using the `call` method.


```r
engine$call("fuse.search", "sense")
#> [1] "d" "c"
```

## Npm Packages {#v8-npm}

We can also use [npm](https://www.npmjs.com/) packages, though not all will work. Npm is node's Package Manager, or in a sense Node's equivalent of CRAN.

To use npm packages we need [browserify](http://browserify.org/), a node library to bundle all dependencies of an npm package into a single file which can subsequently be imported in V8. Browserify is itself an npm package, and therefore requires Node.js to be installed. The reason browserify is required is that the JavaScript code written for Node.js is different from that which should be written for web browsers, therefore importing a Javascript file built with node.js in a browser may not work: browserify will translate node.js code (where necessary) into JavaScript code the browser can run.

You can install browserify globally with the following the `g` flag. Install node.js and type the following the terminal.

```bash
npm install -g browserify
```

We can now "browserify" an npm package. To demonstrate, we will use [ms](https://github.com/zeit/ms), which converts various time formats to milliseconds. First, we install the npm package.

```bash
npm install ms
```

Then we browserify it. From the terminal, the first line creates a file called `in.js` which contains `global.ms = require('ms');` we then call browserify on that file specifying `ms.js` as output file. The `require` function in JavaScript is used to import files, `require('ms')` imports `ms.js`, it's to some extend like `source("ms.R")`.

```bash
echo "global.ms = require('ms');" > in.js
browserify in.js -o ms.js
```

We can now source `ms.js` with v8, before we do so we ought to look at example code to see what has to be reproduced using V8. Luckily the library is very straightforward: it includes a single function for all conversions, e.g.: `ms('2 days')` to convert two days in milliseconds.


```r
library(V8)

ms <- v8()
ms$source("ms.js")
```

Then using the library simply consists of using `eval` or preferably `call` (for cleaner code and data interpretation to R).


```r
ms$eval("ms('2 days')")
#> [1] "172800000"
ms$call("ms", "2s") # 2 seconds
#> [1] 2000
```

## Use in Packages {#v8-pkg}

In this section, we detail how one should go about using V8 in an R package if you are not familiar with package development you can skip ahead. We start by creating a package called "ms" that will hold functionalities we explored in the previous section on npm packages.

```r
usethis::create_package('ms')
```

The package is going to rely on V8 so it needs to be added under `Imports` in the `DESCRIPTION` file, then again this can be done with usethis as shown below.

```r
# add V8 to DESCRIPTION
usethis::use_package("V8")
```

The package should also include the external library `ms.js` browserified from the npm package which should be placed it in the `inst` directory. Create it and place the `ms.js` file within the latter.

```r
dir.create("inst")
```

As explored, the core of the V8 package is the execution environment(s) that are spawned using the `v8` function. One could perhaps provide a function that returns the object created by `v8`, but it would not be convenient: this function would need to be called explicitly by the users of the package and the output of it would need to be passed to every subsequent function. Thankfully there is a better way.

Instead, we can use the function `.onLoad`, to create the execution environment and import the dependency when the package is loaded by the user.

You can read more about this function in Hadley Wickham's [Advanced R book](http://r-pkgs.had.co.nz/r.html). This is in effect very similar to how the Python integration of R, [reticulate](https://rstudio.github.io/reticulate) [@R-reticulate] is [used in packages](https://rstudio.github.io/reticulate/articles/package.html). This function is often placed in a `zzz.R` file.

```r
# zzz.R
ms <- NULL

.onLoad <- function(libname, pkgname){
  ms <<- V8::v8()
}
```

At this stage the package's directory structure should look similar to the tree below.

```bash
.
├── DESCRIPTION
├── NAMESPACE
├── R
│   └── zzz.R
└── inst
    └── ms.js
```

Now the dependency can be sourced in the `.onLoad` function. We can locate the files in the `inst` directory with the `system.file` function.

```r
# zzz.R
ms <- NULL

.onLoad <- function(libname, pkgname){
  ms <<- V8::v8()

  # locate dependency file
  dep <- system.file("ms.js", package = "ms")
  ms$source(dep)
}
```

We can then create a `to_ms` function, it will have access the `ms` object we instantiated in `.onLoad`. 


```r
#' @export
to_ms <- function(string){
  ms$call("ms", string)
}
```

After running `devtools::document()` and installing the package with `devtools::install()` it's ready to used. 


```r
ms::to_ms("10 hrs")
#> [1] 36000000
```
