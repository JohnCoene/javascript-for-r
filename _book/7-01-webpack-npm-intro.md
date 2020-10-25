# (PART) Robust JavaScript {-}

# Managing JavaScript {#webpack-intro}

Thus far all of the JavaScript code written in this book was placed directly in the file that was imported in the front-end, be it htmlwidgets or shiny-related code. While this works for the smaller projects it is bound to lead to headaches for the larger ones.

It's the same problem one faces when writing R code. While a small script of 300 lines of code will do the job a large script of 10,000 lines quickly becomes unmanageable. Therefore when tackling larger projects the R programmer will turn to solutions that enforce a certain file structure and provides utilities harmonise how those files work together. Some of these solutions may include the drake [@R-drake], or targets [@R-targets] packages both of which provide tools to manage complex workflows and pipelines. Another method often used is to build the project as an R package, thereby enforcing a structure as well as enabling reproducibility, unit tests, and more.

The above mentioned issues are also a concern in JavaScript though here one has to consider additional pitfalls. Like R, JavaScript is a constantly evolving language but while R code written on version `4.0.0` will likely run absolutely fine on version `3.0.0` it is not exactly the case for JavaScript. As the language evolves and changes web browsers have to keep up to support any new feature brought by new releases. 

Therefore JavaScript code that is written on the latest version may not run on all browsers, also consider that even if the latest versions of Google Chrome and Mozilla Firefox tend to support the latest JavaScript version, users who visit your shiny applications or use your htmlwidgets may not have their browsers up to date.

In JavaScript, code (mis)management might be exacerbated by the fact that it often relies on other files such as CSS, JSON, images, and more. Making it even more difficult to build robust projects. Moving an image from one folder to another or removing a CSS file may break an entire JavaScript project.

Also, in JavaScript code size matters: the smaller the file the faster it will load in the browser. This is achieved with a process called "minification," which consists in remove all unnecessary characters such as spaces from a JavaScript file to obtain a "minified" version of it that fits on a single line and which is smaller in size. This involves yet another process as humans cannot read or write minified code: try removing all line breaks and spaces from your R scripts if you think otherwise then imagine JavaScript minification takes it a step further.

Finally, since R is rather strict packages enforce a certain structure, JavaScript does not come with such restrictions off the shelf. It's therefore even more tempting for the developer to take shortcuts and make a mess of their projects. 

Combine all of the above and software that involves JavaScript can quickly become poorly structured and cumbersome. Moreover trying to consider all these potential issues as one programs is unsustainable as it greatly increases the cognitive load and ultimately distracts from writing code itself: it's just too much to consider. Thankfully some tools have been invented over the years to help JavaScript developers manage all of these matters. These tools each differ slightly from one another, they each have their pros and cons, but all have the same goal: making JavaScript projects more robust and manageable.

[Grunt](https://gruntjs.com/) describes itself as a "the JavaScript task runner," and will carry minification, compilation, unit testing, linting, and more. There is also [Parcel](https://parceljs.org/) a web application bundler that will minify, bundle, (and more) JavaScript code. However, the one we shall use in this part of the book is [webpack](https://webpack.js.org/), as it is very similar to Grunt and is one of the most popular.

## Example {#webpack-example}

There are admittedly few R packages that make use of such technology though it must be said that many could greatly benefit from it. Given its size and complexity a package such as shiny, however, could probably not do without.

Shiny makes use of Grunt, the source code that comprises all of the JavaScript required to run the front-end (inputs, outpus, modals, etc.) is in the `srcjs` directory which can be seen on [official Github repository](https://github.com/rstudio/shiny). This folder includes a multitude of JavaScript files the name of which indicates the code they encompass; `input_binding_checkbox.js`, `modal.js`, etc.

These files are processed by Grunt which, based on the `Gruntfile.js` configuration file in the `tools` directory, into different bundles that go in the `inst` folder of the package.

## Transpiling {#webpack-browser}

As new functionalities are made available in JavaScript with every new version web browser have to keep pace and support running said functionalities. First, this is not always the case although major web browsers such as Google Chrome, Mozilla Firefox, and Safari generally do a decent job of doing so one can never count on the individuals using those to do keep their browsers up to date.

Imagine building a large htmlwidgets for a client only to discover that for IT security reasons all their company laptops run a certain version of a web browser that does not support key functionalities the widget relies upon.

Ensuring that the JavaScript code can run on most browsers is no trivial task. The best way to do so _is not_ to write outdated JavaScript code that all browsers should support, the solution is actually to use a [Babel](https://babeljs.io/), a transpiler that will convert "ECMAScript 2015+ code into a backwards compatible version of JavaScript." This way one can use the latest JavaScript, even before browsers officially support it, transpile it with Babel to obtain a JavaScript file that will run on any browser that support ECMAScript 2015 (JavaScript version released in 2015).

## Minification {#webpack-minification}

Web browsers always need to load the files necessary to render a webpage, be it a static website, a shiny application, or a standalone widget. Loading those files can take critical time and make the loading of a web application slow. Therefore it is good practice to reduce the size of those files. This includes compressing images so they are smaller in size and load faster but also "minifying" CSS and JavaScript code.

When writing code us humans like to use comprehensible variable names, line breaks, spaces and other things that help make things clear and readable. Machines however do not need much of that, as long as the code is valid it will run. 

```js
// global variable
let number = 41;

// my hello function
function hello(my_variable){
    let total = number + my_variable;
    console.log(total);
}
```

Minification is the process of removing all of the "syntactic sugar" that is unnecessary to obtain JavaScript that fits in a single line and makes for a smaller file. See the example given here where the code above is minified to obtain the code below, note that the comment was removed and even some variable names have changed to be shorter.

```js
let number=41;function hello(e){let l=number+e;console.log(l)}
```

The minified files of a library tend to end in `.min.js` though minified code can very well be placed in a `.js` file.

## Bundling & Modules {#webpack-structure}

Managing the structure of JavaScript projects can be tricky. One does not want to place 2,000 lines of code in a single line but splitting JavaScript code into multiple files is difficult.

While writing an R package one is free to organise the functions in different files as their content (functions, data, etc.) is ultimately loaded into the global environment with `library` by the user of the package.

In JavaScript one does not have the luxury of writing code across different files to then call `library()` in the web browser so all the functions, and variables are available. In this paradigm individual files have to be loaded separately in the browser (as shown below).

```html
<script src="utils.js"></script>
<script src="main.js"></script>
```

While this may be fine for two or three files it quickly goes out of hand as one has to remember to import those in the correct order, in the above example variables declared in `main.js` cannot be used in `utils.js`, unless we change the order of the import in which case something else will likely break.

It's therefore important to use tools that allow splitting JavaScript programs into modules (to write programs in different files), manage the dependencies between these files, then "bundle" those correctly into one or more files destined to be imported in the browser.

## Decoupling {#webpack-decouple}

One thing that might become apparent from the previous sections is the idea of decoupling the final code that makes it into the web browser from the code we write. It is thanks to this decoupling that we can write clear JavaScript code on the latest version across multiple files to then run the various processes of transpiling, 
bundling, and minifying to obtain code that is more efficient and robust for the browser.

This may appear like a lot to manage, thankfully we can use the aforementioned webpack software to take care of all these procedures for us. There is nonetheless a gentle learning curve to make use of it as it involves multiple new concepts. 

Moreover webpack does not limit itself to the aforementioned processes, it can also take care of other things such as removing "dead code," functions or variables that are declared but not used, allows integrating CSS and other files in JavaScript itself, and so much more.

## NPM {#webpack-npm}

Another new piece of software that one needs to be introduced is Node's Package Manager, here henceforth referred to as NPM. As indicated by its name it's a package manager for Node.js, or translated for the R user it's Node's loose equivalent of CRAN. One first major difference is that while CRAN performs very rigorous checks on any package submitted NPM does not, one can publish almost anything.

Notice how every dependency that were used in this book thus far had to be either found through a CDN or manually downloaded, only to be then imported in the final document. Again, this is useful for the smaller projects but may become a hindrance when multiple dependencies have to be managed and updated, added and removed, etc.

NPM has completely changed how dependencies can be managed and imported in JavaScript. It is designed for Node.js code but many (if not all) libraries that are meant to run in web browsers are published on NPM: it's just too convenient.

NPM, combined with the decoupling, and bundling covered in previous sections, enables managing dependencies much more sensibly, and efficiently. So one can, for instance, import only certain functions from an external library rather than the whole thereby further reducing the size of the final bundle of JavaScript files.

## With R {#webpack-conclude}

To be clear, it's not always necessary to involve webpack and NPM into a project, these can take some time to set up and be excessive for smaller project. It's good to be familiar with them as one might want to make use of those in larger projects.

Webpack and NPM were obviously not designed with R in mind so there are some potential issues to consider when using it in packages and shiny applications.

In the following chapter we discover how to include both webpack and NPM to make more robust shiny applications, widgets, and other packages that involve JavaScript and were discussed thus far in the book.
