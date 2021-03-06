# Prerequisites {#prerequisites}



The code contained in the following pages is approachable to readers with basic knowledge of R. Still, familiarity with package development using [devtools](https://devtools.r-lib.org/) [@R-devtools], the [Shiny](https://shiny.rstudio.com/) framework [@R-shiny], the JSON data format, and JavaScript are essential. 

The reason for the former is that some of the ways one builds integrations with JavaScript naturally take the form of R packages. Also, R packages make sharing code, datasets, and anything else R-related extremely convenient, they come with a relatively strict structure, the ability to run unit tests, and much more. These have thus become a core feature of the R ecosystem and, therefore, are used extensively in the book as we create several packages. Therefore, the following section runs over the essentials of building a package to ensure everyone can keep up. 

Then we briefly go through the JSON data format as it will be used to a great extent to communicate between R and JavaScript. Since both Shiny and JavaScript run in the browser\index{web browser} they make for axiomatic companions; we'll therefore use Shiny\index{Shiny} extensively. Finally, there is an obligatory short introduction to JavaScript.

It is highly recommended to use the freely available [RStudio IDE](https://rstudio.com/products/rstudio/)\index{RStudio} to follow along as it makes a lot of things easier down the line.

## R Package Development {#basics-package-dev}

Developing R packages used to be notoriously tricky, but things have considerably changed in recent years, namely thanks to the devtools [@R-devtools], roxygen2 [@R-roxygen2], and more recent [usethis](https://usethis.r-lib.org/) [@R-usethis] packages. Devtools is short for "developer tools," it is specifically designed to help creating packages; setting up tests, running checks, building and installing packages, etc. The second provides an all too convenient way to generate the documentation of packages, and usethis, more broadly, helps setting up projects, and automating repetitive tasks. Here, we only skim over the fundamentals, there is an entire book by Hadley Wickham called [*R Packages*](http://r-pkgs.had.co.nz/) solely dedicated to the topic.

Start by installing those packages from CRAN\index{CRAN} the roxygen2 package does not need to be explicitly installed as it is a dependency\index{dependency} of devtools.

```r
install.packages(c("devtools", "usethis"))
```

### Creating a Package {#basics-create-pkg}

There are multiple ways to create a package. One could manually create every file, use the RStudio IDE\index{RStudio}, or create it from the R console with the usethis [@R-usethis] package.

From the RStudio IDE\index{RStudio} go to `File > New Project > New Directory > R Package` then select "R package" and fill in the small form, namely name the package and specify the directory where it should be created, as shown in Figure \@ref(fig:rstudio-create-package). 

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/rstudio-create-package} 

}

\caption{Package creation wizard}(\#fig:rstudio-create-package)
\end{figure}

But it could be argued that it's actually more accessible from the R console with the usethis package. The `create_package` function takes as first argument the path to create the package. If you run it from RStudio\index{RStudio} a new project window should open.

```r
# creates a package named "test" in root of directory.
usethis::create_package("test")
```

```
✔ Creating 'test/'
✔ Setting active project to '/Packages/test'
✔ Creating 'R/'
✔ Writing 'DESCRIPTION'
Package: test
Title: What the Package Does (One Line, Title Case)
Version: 0.0.0.9000
Authors@R (parsed):
    * First Last <first.last@example.com> [aut, cre] (YOUR-ORCID-ID)
Description: What the package does (one paragraph).
License: `use_mit_license()`, `use_gpl3_license()` or friends to
    pick a license
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.1.1.9000
✔ Writing 'NAMESPACE'
✔ Changing working directory to 'test/'
✔ Setting active project to '<no active project>'
```

### Metadata {#basics-metadata}

Every R package includes a `DESCRIPTION` file which includes metadata about the package. This includes a range of things like the license defining who can use the package, the name of the package, its dependencies\index{dependency}, and more. Below is the default created by the usethis package with `usethis::create_package("test")`.

```
Package: test
Title: What the Package Does (One Line, Title Case)
Version: 0.0.0.9000
Authors@R: 
    person(given = "First",
           family = "Last",
           role = c("aut", "cre"),
           email = "first.last@example.com",
           comment = c(ORCID = "YOUR-ORCID-ID"))
Description: What the package does (one paragraph).
License: `use_mit_license()`, `use_gpl3_license()` or friends to
    pick a license
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.1.1.9000
```

Much of this is outside the scope of the book. However, it is good to grasp how dependencies are specified. As packages are generally intended for sharing with others, it is vital to ensure users of the package meet the dependencies\index{dependency}; otherwise, the package may not work in places. For instance, were we to create a package that relies on one or more functions from the stringr [@R-stringr] package we would need to ensure people who install the package have it installed on their machine or those functions will not work.

```r
# R/string.R
string_length <- function(string) {
  stringr::str_length(string)
}
```

\begin{rmdnote}
Note that the function is preceded by its namespace with \texttt{::}
(more on this later).
\end{rmdnote}

The `DESCRIPTION` file does this; it will make sure that the dependencies\index{dependency} of the package are met by users who install it. We can specify such dependencies\index{dependency} under `Imports`, where we can list packages required separated by a comma.

```
Imports:
  stringr,
  dplyr
```

Then again, the usethis package also allows doing so consistently from the R console, which is great to avoid mishandling the `DESCRIPTION` file.

```r
# add stringr under Imports
usethis::use_package('stringr')
```

One can also specify another type of dependencies\index{dependency} under `Suggests`, other packages that enhance the package but are not required to run it. These, unlike package under `Imports`, are not automatically installed if missing, which can greatly reduce overhead.

### R code {#basics-r-code}

An R package must follow a strict structure. R code must be placed in an `R/` directory so one should only find `.R` files in that directory. These files generally contain functions, methods, and R objects.

```r
# R/add.R
string_length <- function(strings) {
  stringr::str_length(strings)
}
```

### Documentation {#basics-documentation}

Documenting packages used to be notoriously complicated, but thanks to the package roxygen2 that is no longer the case. The documentation of functions of the package (accessible with `?`) and datasets that comprise the package reside in separate files sitting in the `man/` directory. These are `.Rd` files that use a custom syntax resembling LaTex. The roxygen package eases the creation of these files by turning special comments and tags in `.R` files into said `.Rd` files. 

Special comments are a standard R comment `#` followed by an apostrophe `'`. The first sentence of the documentation is the title of the documentation file while the second is the description.

```r
#' Strings Length
#' 
#' Returns the number of characters in strings. 
string_length <- function(strings) {
  stringr::str_length(strings)
}
```

There are a plethora of roxygen2 tags to further document different sections. Below we use two different tags to document the parameters and give an example. 

```r
#' Strings Length
#' 
#' Returns the number of characters in strings. 
#' 
#' @param strings A vector of character strings.
#' 
#' @example string_length(c("hello", "world"))
string_length <- function(strings) {
  stringr::str_length(strings)
}
```

As well as generating documentation, the roxygen2 package also allows populating the `NAMESPACE` file. This is an extensive and often confusing topic, but for this book, we'll be content with the following: the `NAMESPACE` includes functions that are _imported_ and _exported_\index{export} by the package.

By default, functions that are present in the R files in the `R/` directory are not exported: they are not accessible outside the package. Therefore the `string_length` function defined previously will not be made available to users of the package, only other functions within the package will be able to call it. To export it we can use the `@export` tag\index{export}. This will place the function as exported in the `NAMESPACE` file.

```r
#' Strings Length
#' 
#' Returns the number of characters in strings. 
#' 
#' @param strings A vector of character strings.
#' 
#' @example string_length(c("hello", "world"))
#' 
#' @export
string_length <- function(strings) {
  stringr::str_length(strings)
}
```

There are two ways to use external functions (functions from other R packages), as done thus far in the `string_length` function by using the namespace (package name) to call the function: `stringr::str_length`. Or by importing the function needed using a roxygen2 tag thereby removing the need for using the namespace. 

```r
#' Strings Length
#' 
#' Returns the number of characters in strings. 
#' 
#' @param strings A vector of character strings.
#' 
#' @example string_length(c("hello", "world"))
#' 
#' @importFrom stringr str_length
#' 
#' @export
string_length <- function(strings) {
  str_length(strings) # namespace removed
}
```

Above we import the function `str_length` from the `stringr` package using the `importFrom` roxygen2 tag. The first term following the tag is the name of the package wherefrom to import the functions, and the following terms are the name of the functions separated by spaces so one can import multiple functions from the same package with, e.g.: `@importFrom stringr str_length str_to_upper`. If the package imports many functions from a single package one might also consider importing the package in its entirety with, e.g.: `@import stringr`.

Finally, one can actually generate the `.Rd` documentation files and populate the `NAMESPACE` with either the `devtools::document()` function or `roxygen2::roxygenise()`.

\begin{rmdnote}
Remember to run \texttt{devtools::document()} after changing roxygen2
tags otherwise changes are not actually reflected in the
\texttt{NAMESPACE} and documentation.
\end{rmdnote}

### Installed files {#basics-installed-files}

Here we tackle the topic of installed files as it will be relevant to much of what the book covers. Installed files are files that are downloaded and copied as-is when users install the package. This directory will therefore come in very handy to store JavaScript files that package will require. These files can be accessed with the `system.file` function, which will look for a file from the root of the `inst/` directory.

```r
# return path to `inst/dependency.js` in `myPackage`
path <- system.file("dependency.js", package = "myPackage")
```

### Build, load, and install {#basics-build-load-install}

Finally, after generating the documentation of the package with `devtools::document()` one can install it locally with `devtools::install()`. This, however, can take a few seconds too many whilst developing a package as one iterates and regularly tries things; `devtools::load_all()` will not install the package but load all the functions and object in the global environment\index{environment} to let you run them.

There is some cyclical nature to developing packages:

1. Write some code
2. Run `devtools::document()` (if documentation tags have changed)
3. Run `devtools::load_all()`
4. Repeat

Note whilst this short guide will help you develop packages good enough for your system it will certainly not pass \index{CRAN} checks.

## JSON {#basics-json}

JSON\index{JSON} (JavaScript Object Notation) is a prevalent data _interchange_ format with which we will work extensively throughout this book; it is thus crucial that we have a good understanding of it before we plunge into the nitty-gritty. As one might foresee, if we want two languages to work together, we must have a data format that can be understood by both---JSON\index{JSON} lets us harmoniously pass data from one to the other. While it is natively supported in JavaScript, it can be graciously handled in R with the [jsonlite package](https://CRAN.R-project.org/package=jsonlite) [@R-jsonlite] it is the serialiser used internally by all R packages that we explore in this book.

\begin{rmdnote}
``To serialise''\index{serialise} is just jargon for converting data to
JSON.
\end{rmdnote}

### Serialising {#serialising}

JSON\index{JSON} is to all intents and purposes the equivalent of lists in R; a flexible data format that can store pretty much anything--except data.frames, a structure that does not exist in JavaScript. Below we create a nested list and convert it to JSON\index{JSON} with the help of jsonlite. We set `pretty` to `TRUE` to add indentation for cleaner printing, but this is an argument you should omit when writing production code; it will reduce the file size (fewer spaces = smaller file size). 


```r
# install.packages("jsonlite")
library(jsonlite)

lst <- list(
  a = 1,
  b = list(
    c = c("A", "B")
  ),
  d = 1:5
)

toJSON(lst, pretty = TRUE)
#> {
#>   "a": [1],
#>   "b": {
#>     "c": ["A", "B"]
#>   },
#>   "d": [1, 2, 3, 4, 5]
#> }
```

Looking closely at the list and JSON output above, one quickly sees the resemblance. Something seems odd though: the first value in the list (`a = 1`) was serialised\index{serialise} to an array (vector) of length one (`"a": [1]`), where one would probably expect an integer instead, `1` not `[1]`. This is not a mistake; we often forget that there are no scalar types in R and that `a` is, in fact, a vector as we can observe below.


```r
x <- 1
length(x)
#> [1] 1
is.vector(x)
#> [1] TRUE
```

JavaScript, on the other hand, does have scalar types; more often than not we will want to convert the vectors of length one to scalar types rather than arrays of length one. To do so we need to use the `auto_unbox` argument in `jsonlite::toJSON`; we'll do this most of the time we have to convert data to JSON\index{JSON}.


```r
toJSON(lst, pretty = TRUE, auto_unbox = TRUE)
#> {
#>   "a": 1,
#>   "b": {
#>     "c": ["A", "B"]
#>   },
#>   "d": [1, 2, 3, 4, 5]
#> }
```

As demonstrated above the vector of length one was "unboxed" into an integer; with `auto_unbox` set to `TRUE`, jsonlite will properly convert such vectors into their appropriate type integer, numeric, boolean, etc. Note that this only applies to vectors lists of length one will be serialised\index{serialise} to arrays of length one even with `auto_unbox` turned on: `list("hello")` will always be converted to `["hello"]`.

### Tabular Data {#basics-tabular}

If JSON is more or less the equivalent of lists in R one might wonder how jsonlite handles dataframes since they do not exist in JavaScript.


```r
# subset of built-in dataset
df <- cars[1:2, ]

toJSON(df, pretty = TRUE)
#> [
#>   {
#>     "speed": 4,
#>     "dist": 2
#>   },
#>   {
#>     "speed": 4,
#>     "dist": 10
#>   }
#> ]
```

What jsonlite does internally is essentially turn the data.frame into a list _row-wise_ to produce a sub-list for every row then it serialises to JSON. This is generally how rectangular data is represented in lists. For instance, `purrr::transpose` does the same. Another great example is to use `console.table` in the JavaScript console (more on that later) to display JSON\index{JSON} data as a table (see Figure \@ref(fig:console-table)).

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/console-table} 

}

\caption{console.table output}(\#fig:console-table)
\end{figure}

We can reproduce this with the snippet below; we remove row names and use apply to turn every row into a list.


```r
row.names(df) <- NULL
df_list <- apply(df, 1, as.list)

toJSON(df_list, pretty = TRUE, auto_unbox = TRUE)
#> [
#>   {
#>     "speed": 4,
#>     "dist": 2
#>   },
#>   {
#>     "speed": 4,
#>     "dist": 10
#>   }
#> ]
```

Jsonlite of course also enables reading data from JSON\index{JSON} into R with the function `fromJSON`.


```r
json <- toJSON(df) # convert to JSON
fromJSON(json) # read from JSON
#>   speed dist
#> 1     4    2
#> 2     4   10
```

It's important to note that jsonlite did the conversion back to a data frame. Therefore the code below also returns a data frame even though the object we initially converted to JSON\index{JSON} is a list.


```r
class(df_list)
#> [1] "list"
json <- toJSON(df_list)
fromJSON(json)
#>   speed dist
#> 1     4    2
#> 2     4   10
```

Jsonlite provides many more options and functions that will let you tune how JSON data is read and written. Also, the jsonlite package does far more than what we detailed in this section. But at this juncture, this is an adequate understanding of things.

## JavaScript {#basics-javascript}

The book is not meant to teach JavaScript, only to show how graciously it can work with R. Let us thus go through the very basics to ensure we know enough to get started with the coming chapters.

The easiest way to run JavaScript interactively is probably to create an HTML\index{HTML} file (e.g.: `try.html`), write your code within a `<script>` tag and open the file in your web browser\index{web browser}. The console output can be observed in the console of the browser, developer tools (see Figure \@ref(fig:trying-js)).

```html
<!–– index.html ––>
<html>
  <head>
  </head>
  <body>
    <p id="content">Trying JavaScript!</p>
  </body>
  <script>
    // place your JavaScript code here
    console.log('Hello JavaScript!')
  </script>
</html>
```

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/tryingjs} 

}

\caption{Trying JavaScript}(\#fig:trying-js)
\end{figure}

### Developer Tools {#basics-chrome-devtools}

Most of the JavaScript code written in this book is intended to be run in web browsers\index{web browser}; it is thus vital that you have a great understanding of your web browser\index{web browser} and its developer tools (devtools). In this section, we discuss those available in Google Chrome and Chromium, but such tools, albeit somewhat different, also exist in Mozilla Firefox and Safari.

\begin{rmdnote}
The RStudio IDE\index{RStudio} is built on Chromium, some of these tools
will therefore also work in RStudio.
\end{rmdnote}

The easiest way to access the developer tools from the browser is by "inspecting": right-click on an element on a webpage and select "inspect." This will open the developer tools either at the bottom or on the right (Figure \@ref(fig:chrome-devtools)) of the page depending on the defaults.

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/devtools} 

}

\caption{Google Chrome devtools}(\#fig:chrome-devtools)
\end{figure}

The developer tools pane consists of several tabs but we will mainly use:

1. Elements: presents the DOM\index{DOM} Tree, the HTML document structure, great for inspecting the structure of the outputs generated from R.
2. Console: the JavaScript console where messages, errors, and other such things are logged. Essential for debugging.

### Variable Declaration and Scope {#basics-var-scope}

One significant way JavaScript differs from R is that variables must be declared using one of three keywords, `var`, `let`, or `const`, which mainly affect the scope\index{scope} where the declared variable will be accessible.

```js
x = 1; // error
var x = 1; // works
```

One can declare a variable without assigning a value to it, to then do so later on. 

```js
var y; // declare 
y = [1,2,3]; // define it as array
y = 'string'; // change to character string
```

The `let` and `const` keywords were added in ES2015\index{ECMA}; the `const` is used to define a constant: a variable that once declared cannot be changed.

```js
const x = 1; // declare constant
x = 2; // error
```

Though this is probably only rarely done in R, one can produce something similar by locking the binding for a variable in its \index{environment}.

```r
x <- 1 # declare x
lockBinding("x", env = .GlobalEnv) # make constant
x <- 2 # error
unlockBinding("x", env = .GlobalEnv) # unlock binding
x <- 2 # works
```

Notably, `const` is mainly protecting yourself (the developer) against yourself; if something important is defined and should not change later in the code use `const` to avoid accidentally reassigning\index{scope} something to it later in the project.

The `let` keyword is akin to declaring a variable with the `var` keyword. However, `let` (and `const`) will declare the variable in the "block scope." In effect, this further narrows down the scope where the variable will be accessible. A block scope\index{scope} is generally the area within `if`, `switch` conditions or `for` and `while` loops: areas within curly brackets.

```js
if(true){
  let x = 1;
  var y = 1;
}

console.log(x) // error x does not exist
console.log(y) // works
```

In the above example, `x` is only accessible within the if statement as it is declared with `let`, `var` does not have block scope. 

While on the subject of scope, in R like in JavaScript, variables can be accessed from the parent environment\index{environment} (often referred to as "context" in the latter). One immense difference though is that while it is seen as bad practice in R, it is not in JavaScript where it is beneficial.


```r
# it works but don't do this in R
x <- 123
foo <- function(){
  print(x)
}
foo()
#> [1] 123
```

The above R code can be re-written in JavaScript. Note the slight variation in the function declaration.

```js
// this is perfectly fine
var x = 1;

function foo(){
  console.log(x); // print to console
}

foo();
```

\begin{rmdnote}
Accessing variables from the parent \index{environment} (context) is
useful in JavaScript but should not be done in R
\end{rmdnote}

### Document Object Model {#basics-object-model}

One concept does not exist in R is that of the "DOM" which stands for Document Object Model; this is also often referred to as the DOM\index{DOM} tree (represented in Figure \@ref(fig:dom-viz)) as it very much follows a tree-like structure.

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/02-dom-viz} 

}

\caption{Document Object Model visualisation}(\#fig:dom-viz)
\end{figure}

When a web page is loaded, the browser creates a Document Object Model of the web page, which can be accessed in JavaScript from the `document` object. This lets the developer programmatically manipulate the page itself so one can, for instance, add an element (e.g., a button), change the text of another, and plenty more.

The JavaScript code below grabs the element where `id='content'` from the `document` with `getElementById` and replaces the text (`innerText`). Even though the page only contains "Trying JavaScript!" when the page is opened (loaded) in the web browser\index{web browser} JavaScript runs the code and changes it: this happens very fast so the original text cannot be seen.

```html
 <!–– index.html ––>
<html>
  <head>
  </head>
  <body>
    <p id="content">Trying JavaScript!</p>
  </body>
  <script>
    var cnt = document.getElementById("content");
    cnt.innerText = "The text has changed";
  </script>
</html>
```

One final thing to note for future reference: though not limited to the ids or classes most of such selection of elements from the DOM are done with those where the pound sign refers to an element's id (`#id`) and a dot relates to an element's class (`.class`), just like in CSS.

```html
 <!–– index.html ––>
<html>
  <head>
  </head>
  <body>
    <p id="content" class="stuff">Trying JavaScript!</p>
  </body>
  <script>
    // select by id
    var x = document.getElementById("content");
    var y = document.querySelector("#content");

    console.log(x == y); // true

    // select by class
    var z = document.querySelector(".stuff");
  </script>
</html>
```

Getting elements from the DOM is a very common operation in JavaScript. A class can be applied to multiple elements, which is useful to select and apply actions to multiple elements. The id attribute must be unique (two elements cannot bear the same id in the HTML document), which is useful to retrieve a specific element. 

Interestingly some of that mechanism is used by Shiny to retrieve and manipulate inputs; the argument `inputId` of Shiny inputs effectively defines the HTML `id` attribute of said input. Shiny can then internally use functions the likes of `getElementById` in order to get those inputs, set or update their values, etc.

```r
shiny::actionButton(inputId = "theId", label = "the label") 
```

```html
<button 
  id="theId" 
  type="button" 
  class="btn btn-default action-button">
  the label
</button>
```

This, of course, only scratches the surface of JavaScript; thus, this provides ample understanding of the language to keep up with the next chapters. Also, a somewhat interesting fact that will prove useful later in the book: the RStudio IDE is actually a browser, therefore, in the IDE, one can right-click and "inspect element" to view the rendered source code.

## Shiny {#basics-shiny}

It is assumed that the reader has basic knowledge of the Shiny\index{Shiny} framework and already used it to build applications. However, there are some more obscure functionalities that one may not know, but that becomes essential when introducing JavaScript to applications. Chiefly, how to import external dependencies\index{dependency}; JavaScript or otherwise.

There are two ways to import dependencies\index{dependency}: using the htmltools [@R-htmltools] package to create a dependency object that Shiny can understand, or manually serving and importing the files with Shiny.

### Serving Static Files {#basics-static-files}

Static files are files that are downloaded by the clients, in this case, web browsers accessing Shiny applications, as-is. These generally include images, CSS (`.css`), and JavaScript (`.js`).

If you are familiar with R packages, static files are to Shiny applications what the `inst` directory is to an R package; those files are installed as-is. They do not require further processing as opposed to the `src` folder, which contains files that need compiling, for instance.

There are numerous functions to launch a Shiny application locally; the two most used are probably `shinyApp` and `runApp`. The RStudio IDE comes with a convenient "Run" button when writing a shiny application, which when clicked in fact uses the function `shiny::runApp` in the background. This function looks for said static files in the `www` directory and makes them available at the same path (`/www`). If you are building your applications outside of RStudio\index{RStudio}, you should either also use `shiny::runApp` or specify the directory which then allows using `shiny::shinyApp`. Note that this only applies locally; Shiny server (community and pro) as well as [shinyapps.io](https://www.shinyapps.io/) use the same defaults as the RStudio IDE and `shiny::runApp`.

To ensure the code in this book can run regardless of the reader's machine or editor, the asset\index{asset} directory is always specified explicitly (when used). This is probably advised to steer clear of the potential headaches as, unlike the default, it'll work regardless of the environment\index{environment}. If you are using golem [@R-golem] to develop your application, then you should not worry about this as it specifies the directory internally.

Below we build a basic Shiny\index{Shiny} application. However, before we define the `ui` and `server`, we use the `shiny::addResourcePath` function to specify the location of the directory of static files that will be served by the server and thus accessible by the client. This function takes two arguments: first the `prefix`, which is the path (URL) at which the assets\index{asset} will be available, second the path to the directory of static assets.

We thus create the "assets"\index{asset} directory and a JavaScript file called `script.js` within it.

```r
# run from root of app (where app.R is located)
dir.create("assets")
writeLines("console.log('Hello JS!');", con = "assets/script.js")
```

We can now use the `shiny::addResourcePath` to point to this directory. Generally, the same name for the directory of static assets\index{asset} and prefix is used to avoid confusion; below we name them differently for the reader to clearly distinguish which is which.

```r
# app.R
library(shiny)

# serve the files
addResourcePath(
  # will be accessible at /files
  prefix = "files", 
  # path to the assets directory
  directoryPath = "assets"
)

ui <- fluidPage(
  h1("R and JavaScript")
)

server <- function(input, output){}

shinyApp(ui, server)
```

If you then run the application and open it at the `/files/script.js` path (e.g.: `127.0.0.1:3000/files/script.js`) you should see the content of the JavaScript file (`console.log('Hello JS!')`), commenting the `addResourcePath` line will have a "Not Found" error displayed on the page instead.

\begin{rmdnote}
All files in your asset\index{asset} directory will be served online and
accessible to anyone: do not place sensitive files in it.
\end{rmdnote}

Though one may create multiple such directories and correspondingly use `addResourcePath` to specify multiple paths and prefixes, one will routinely specify a single one, named "assets"\index{asset} or "static," which contains multiple subdirectories, one for each type of static file to obtain a directory that looks something like the tree below. This is, however, an unwritten convention which is by no means forced upon the developer: do as you wish.

```
assets/
├── js/
│    └── script.js
├── css/
│    └── style.css
└── img/
     └── pic.png
```

At this stage, we have made the JavaScript file we created accessible by the clients, but we still have to source this file in the `ui` as currently this file is, though served, not used by the application. Were one creating a static HTML\index{HTML} page one would use the `script` to `src` the file in the `head` of the page.

```html
<html>
  <head>
    <!–– source the JavaScript file ––>
    <script src="path/to/script.js"></script>
  </head>
  <body>
    <p id="content">Trying JavaScript!</p>
  </body>
</html>
```

In Shiny\index{Shiny} we write the UI in R and not in HTML (though this is also supported). Given the resemblance between the names of HTML tags and Shiny UI functions, it is pretty straightforward; the html page above would look something like the Shiny `ui` below. 

```r
library(shiny)

ui <- fluidPage(
  singleton(
    tags$head(
      tags$script(src = "path/to/script.js")
    )
  ),
  p(id = "content", "Trying JavaScript!")
)
```

The dependency\index{dependency} is used in the `htmltools::singleton` function ensures that its content is _only imported in the document once._ 

Note that we use the `tags` object, which comes from the Shiny package and includes HTML\index{HTML} tags that are not exported\index{export} as standalone functions. For instance, you can create a `<div>` in Shiny with the `div` function, but `tags$div` will also work. This can now be applied to the Shiny application; the `path/to/script.js` should be changed to `files/script.js`, where `files` is the prefix we defined in `addResourcePath`.

```r
# app.R
library(shiny)

# serve the files
addResourcePath(prefix = "files", directoryPath = "assets")

ui <- fluidPage(
  tags$head(
    tags$script(src = "files/script.js")
  ),
  h1("R and JavaScript")
)

server <- function(input, output){}

shinyApp(ui, server)
```

From the browser, inspecting page (right click > inspect > console tab) one should see `Hello JS!` in the console, which means the application correctly ran the code in the JavaScript file.

### Htmltools {#basics-htmltools}

The htmltools package powers much of the Shiny UI, most of the tags that comprise the UI are indeed imported by Shiny from htmltools. For instance `shiny::actionButton` is just a light wrapper around htmltools `tags`.

```r
shiny::actionButton
```

```r
function (inputId, label, icon = NULL, width = NULL, ...) 
{
    value <- restoreInput(id = inputId, default = NULL)
    tags$button(
      id = inputId, style = if (!is.null(width)) 
      paste0("width: ", validateCssUnit(width), ";"),
      type = "button", class = "btn btn-default action-button", 
      `data-val` = value, list(validateIcon(icon), label), 
      ...
    )
}
```

As the name indicates, htmltools goes beyond the generation of HTML tags and provides broader tools to work with HTML from R; this includes working the dependencies. These may appear simple at first: after all, were one working with an HTML document in order to import HTML\index{HTML} or CSS one could use HTML tags.

```html
 <!–– index.html ––>
<html>
  <head>
    <script src="path/to/script.js"></script>
    <link rel="stylesheet" href="path/to/styles.css">
  </head>
  <body></body>
</html>
```

However, it can quickly get out of hand when working with modules and packages. Imagine having to manage the generation of dependencies, such as the above when multiple functions rely on a dependency\index{dependency}, but being a dependency, it should only be imported once? The unified framework htmltools helps immensely in dealing with these sorts of issues.

The htmltools package provides utilities to import dependencies and ensure these are only rendered once, as they should be. The way this works is by creating a dependency\index{dependency} object that packages like Shiny and R markdown\index{R markdown} can understand and translate into HTML dependencies. This is handled with the `htmlDependency` function, which returns an object of class `html_dependency`.

```r
dependency <- htmltools::htmlDependency(
  name = "myDependency",
  version = "1.0.0",
  src = c(file = "path/to/directory"),
  script = "script.js",
  stylesheet = "styles.css"
)
```

About the above, the `src` argument points to the directory that contains the dependencies\index{dependency} (`script` and `stylesheet`); this is done with a named vector where `file` indicates the path is a local directory and `href` indicates it is a remote server, generally a CDN\index{CDN}. Note that one can also pass multiple `script` and `stylesheet` by using vectors, e.g.: `c("script.js", "anotherScript.js")`

\begin{rmdnote}
CDN stands for Content Delivery Network, a geographically distributed
group of servers that provide fast transfer of
dependencies\index{dependency}.
\end{rmdnote}

```r
# dependency to the latest jQuery
dependency <- htmltools::htmlDependency(
  name = "myDependency",
  version = "1.0.0",
  src = c(
    href = "https://cdn.jsdelivr.net/gh/jquery/jquery/dist/"
  ),
  script = "jquery.min.js"
)
```

Shiny, R markdown, and other packages where htmltools is relevant will then be able to translate an `html_dependency` object into actual HTML dependencies. The above would, for instance, generate the following HTML.

```html
<script 
  src="https://cdn.jsdelivr.net/gh/jquery/jquery/
    dist/jquery.min.js">
</script>
```

Notably, the `htmltools::htmlDependency` also takes a `package` argument, which makes it such that the `src` path becomes relative to the package directory (the `inst` folder). Hence the snippet below imports a file located at `myPackage/inst/assets/script.js`; the ultimate full path will, of course, depend on where the package is installed on the users' machine.

```r
dependency <- htmltools::htmlDependency(
  name = "myDependency",
  version = "1.0.0",
  src = "assets",
  script = c(file = "script.js"),
  package = "myPackage" # user package
)
```

However, how does one use it in R markdown\index{R markdown} or Shiny? Well, merely placing it in the Shiny UI or an evaluated R markdown\index{R markdown} chunk will do the job.

```r
# place it in the shiny UI
ui <- fluidPage(
  htmltools::htmlDependency(
    name = "myDependency",
    version = "1.0.0",
    src = "assets",
    script = c(file = "script.js"),
    package = "myPackage" # user package
  )
)
```

### Serving vs. htmltools {#basics-deps-pro-cons}

For multiple reasons, the best way to include dependencies\index{dependency} is probably the former using htmltools. First, it will work with both Shiny and rmarkdown [@R-rmarkdown] (whereas the other method previously described only works with Shiny), reducing the cognitive load on the developer (you). Learn to use this method and you will be able to import dependencies\index{dependency} for many different output types. Moreover, it comes with neat features that will be explored later in the book, e.g., dynamic dependencies for interactive visualisations or Shiny.

Also, using htmltools dependencies will allow other package developers to assess and access the dependencies you build quickly. The function `findDependencies` will accept another function from which it can extract the dependencies\index{dependency}. The object it returns can then be used elsewhere, making dependencies portable. Below we use this function to extract the dependencies of the `fluidPage` function from the Shiny package.

```r
htmltools::findDependencies(
  shiny::fluidPage()
) 
```

```
#> [[1]]
#> List of 10
#>  $ name      : chr "bootstrap"
#>  $ version   : chr "3.4.1"
#>  $ src       :List of 2
#>   ..$ href: chr "shared/bootstrap"
#>   ..$ file: chr "/Library/shiny/www/shared/bootstrap"
#>  $ meta      :List of 1
#>   ..$ viewport: chr "width=device-width, initial-scale=1"
#>  $ script    : chr [1:3] "js/bootstrap.min.js" 
  "shim/html5shiv.min.js" 
  "shim/respond.min.js"
#>  $ stylesheet: chr "css/bootstrap.min.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi TRUE
#>  - attr(*, "class")= chr "html_dependency"
```

Extracting dependencies\index{dependency} from other packages will become useful later in the book as we assess compatibility between packages: making sure dependencies do not clash and importing dependencies\index{dependency} from other packages.

Using `shiny::addResourcePath` has one advantage: its use is not limited to making CSS and JavaScript files available in Shiny; it can be used to serve other file types such as JSON or images that may also be needed in the application.

