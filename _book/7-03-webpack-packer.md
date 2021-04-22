# Webpack with R {#packer-overview}

In the previous chapter, we put together a simple Shiny application using NPM and webpack. Hopefully, it hinted at some of the powerful things webpack can do but also revealed a downside: the overhead in merely creating the project. Moreover, the configuration will change depending on what the project is (application, package, etc.).

In this chapter, we discover the [packer](https://github.com/JohnCoene/packer) [@R-packer] R package, which provides many convenience functions to create and manage R projects that make use of webpack and NPM.

```r
install.packages("packer")
```

## Principles of packer {#packer-principles}

There are a few principles that the packer package follows strictly.

1. It only aspires to become a specialised usethis for working with JavaScript and R. As such, it takes inspiration from other packages such as htmlwidgets and devtools.
2. It will never become a dependency\index{dependency} to what you create. It's in a sense very much like an NPM "developer" dependency; it's used to develop the project but does not bring any additional overhead to what you're building.
3. It should not interfere with the mission of webpack to build more robust JavaScript code. Therefore, packer only builds on top of already, strict R structures, namely packages (where golem can be used to create Shiny applications).

## Scaffolds {#packer-scaffolds}

Packer is comprised of surprisingly few functions; the most important ones are in the `scaffold` family. The term scaffold was borrowed from the htmlwidgets package, which features the function `scaffoldWidget` (already used in this book). The idea of scaffolds in packer is very similar to the `scaffoldWidget` function: they set up the basic structure for projects.

Whilst htmlwidgets only allows creating scaffolds\index{scaffold} for widgets; packer allows creating scaffolds for several things, namely:

- Widgets with `scaffold_widget`
- Shiny inputs with `scaffold_input`
- Shiny outputs with `scaffold_output`
- Shiny extensions with `scaffold_extension`
- Golem applications with `scaffold_golem`

This gives a few powerful functions that correctly set up webpack. These will build the necessary file structure and configuration depending on the scaffold and the context (whether it is a basic package, a golem application, a package with an existing scaffold, etc.)

\begin{rmdnote}
One can use multiple scaffolds in a single package or Shiny application.
\end{rmdnote}

Packer goes beyond merely setting up webpack and NPM; it will also create the necessary R functions, roxygen documentation, and examples, so every scaffold is fully functional out-of-the-box.

With some variations that will be explored in the coming sections, packer's `scaffold` functions generally do the following:

- Initialise npm with `npm init` and prefills the `package.json` file
- Install webpack and its CLI with `npm install webpack webpack-cli --save-dev`
- Creates three webpack configuration files: `webpack.common.js`, `webpack.prod.js`, and `webpack.dev.js`
- Creates the `srcjs` directory for the JavaScript source code
- Creates raw JavaScript files within the `srcjs` directory, e.g.: `index.js`
- Creates the R functions (if necessary)
- Adds the necessary NPM scripts to `package.json`
- Adds all relevant files to the `.Rbuildignore` and `.gitignore` files
- Adds relevant dependencies to the `DESCRIPTION`, e.g.: `shiny` when scaffolding an input
- Finally, it (optionally) opens interesting files to develop the project in the IDE

In the following sections, we unpack some of this as we explore a specific scaffold.

## Inputs {#packer-inputs}

In a previous chapter, we explored how to build custom Shiny inputs. Here, we'll use the packer package to produce a Shiny button that increments at every click; hence we create a package called "increment."

```r
usethis::create_package("increment")
```

From the root of the package, we scaffold a custom input. Notably, this takes a `name` argument, which is used as names for the various files, functions, and modules it creates so choose it with care. The function prints some information about the operations it executes. 

When run from an interactive session, packer also opens the most pertinent files in the default editor or IDE.

```r
packer::scaffold_input("increment")
```

```bash
── Scaffolding shiny input ──────────────────────────────────────── increment ── 
✔ Initialiased npm
✔ Created srcjs/inputs directory
✔ Created inst/packer directory
✔ webpack, webpack-cli, webpack-merge installed with scope dev
✔ Created srcjs/config directory
✔ Created webpack config files
✔ Created 'input' module
✔ Created srcjs/index.js
✔ Created R file and function
✔ Added npm scripts

── Adding files to '.gitignore' and '.Rbuildignore' ──

✔ Setting active project to '/javascript-for-r/code/increment'
✔ Adding '^srcjs$' to '.Rbuildignore'
✔ Adding '^node_modules$' to '.Rbuildignore'
✔ Adding '^package\\.json$' to '.Rbuildignore'
✔ Adding '^package-lock\\.json$' to '.Rbuildignore'
✔ Adding '^webpack\\.dev\\.js$' to '.Rbuildignore'
✔ Adding '^webpack\\.prod\\.js$' to '.Rbuildignore'
✔ Adding '^webpack\\.common\\.js$' to '.Rbuildignore'
✔ Adding 'node_modules' to '.gitignore'

── Adding packages to Imports ──

✔ Adding 'shiny' to Imports field in DESCRIPTION
● Refer to functions with `shiny::fun()`
✔ Adding 'htmltools' to Imports field in DESCRIPTION
● Refer to functions with `htmltools::fun()`

── Scaffold built ──

ℹ Run `bundle` to build the JavaScript files
```

The scaffold\index{scaffold} creates the file structure below. Notice that `increment` was used as the name of some files and that packer creates three webpack configuration files; one for development, another for production, and a third that contains configuration shared across those two modes.

It created one R file, `increment.R`, which contains the exported\index{export} input function named `incrementInput`. It also created the `inst/packer` directory, which is currently empty but will eventually contain the bundled JavaScript file(s).

The function also initialised NPM, which created the `node_modules` directory, as well as the `package.json` and `package-lock.json`, packer also added the necessary scripts to `package.json` so one should not need to interact with those files directly.

Finally, it also created the `srcjs` directory containing core JavaScript files to produce the input binding.

```
.
├── DESCRIPTION
├── NAMESPACE
├── R
│   ├── increment.R
├── inst
│   └── packer
├── node_modules
│   └── ...
├── package.json
├── srcjs
│   ├── config
│   ├── inputs
│   └── index.js
├── webpack.common.js
├── webpack.dev.js
└── webpack.prod.js
```

In the following sections, we break down those files to better understand what packer scaffolded and how to use it.

## R file {#packer-r-file}

The R file contains the `incrementInput` function. Notably, the function contains the necessary dependency\index{dependency}, although it currently looks for a file that is yet created (we'll bundle the JavaScript later). Also, of importance is the class attribute set for the input: `incrementBinding`. As you might remember, this class will be referenced in the JavaScript binding's `find` method.

```r
incrementInput <- function(inputId, value = 0){

  stopifnot(!missing(inputId))
  stopifnot(is.numeric(value))

  dep <- htmltools::htmlDependency(
    name = "incrementBinding",
    version = "1.0.0",
    src = c(file = system.file("packer", package = "increment")),
    script = "increment.js"
  )

  tagList(
    dep,
    tags$button(
      id = inputId,
      class = "incrementBinding btn btn-default",
      type = "button",
      value
    )
  )
}
```

Note that packer does not use the namespace of functions (e.g., `shiny::tagList`). Instead, it uses the roxygen2 tags to import the necessary functions: `@importFrom Shiny tags tagList`. Rather nicely, packer also created an example in the roxygen documentation. We'll run this later after we've bundled the JavaScript.

```r
#' @examples 
#' library(shiny)
#' 
#' ui <- fluidPage(
#'  incrementInput("theId", 0)
#' )
#' 
#' server <- function(input, output){
#' 
#'  observeEvent(input$theId, {
#'    print(input$theId)
#'  })
#' 
#' }
#' 
#' if(interactive())
#'  shinyApp(ui, server)
```

## JavaScript Files {#packer-js-files}

In the `srcjs/inputs` directory, packer created `increment.js`. This code contains the JavaScript binding for the increment button. As a reminder, one is not limited to a single scaffold. We could scaffold another input, the JavaScript binding of which would be placed alongside this file, also in `srcjs/inputs`.

```js
import $ from 'jquery';
import 'shiny';

$(document).on("click", "button.incrementBinding", 
  function(evt) {
    // evt.target is the button that was clicked
    var el = $(evt.target);

    // Set the button's text to its current value plus 1
    el.text(parseInt(el.text()) + 1);

    // Raise an event to signal that the value changed
    el.trigger("change");
  }
);

var incrementBinding = new Shiny.InputBinding();

$.extend(incrementBinding, {
  find: function(scope) {
    return $(scope).find(".incrementBinding");
  },
  getValue: function(el) {
    return parseInt($(el).text());
  },
  setValue: function(el, value) {
    $(el).text(value);
  },
  subscribe: function(el, callback) {
    $(el).on("change.incrementBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".incrementBinding");
  }
});

Shiny.inputBindings.register(
  incrementBinding, "increment.incrementBinding"
);
```

The `srcjs/index.js` file was also created; it imports the JavaScript binding detailed above with `import './inputs/increment.js';`. Notably, by default, packer does not bundle all of these files into one; `index.js` is only populated for convenience in the event one would want to change this behaviour. Instead, packer uses `srcjs/inputs/increment.js` as an entry point. It will handle multiple entry points, so every input, output, widgets, etc. are bundled separately. This is done so one can import those dynamically.

## Bundle {#packer-bundle}

You can then run `packer::bundle` to bundle the JavaScript. The entry points and output directories will depend on the scaffold, Shiny inputs' bundles are placed in the `inst/packer` directory unless this was run from a golem application, in which case the output is automatically changed to golem's standard.

```r
packer::bundle()
```

By default packer will bundle the files for production, this can be managed with the functions `packer::bundle_dev()` and `packer::bundle_prod()`. 

Once the JavaScript is bundled, we can install or load the package with `devtools::load_all` and use the example that was created for us to test the input.

```r
library(shiny)

ui <- fluidPage(
  incrementInput("theId", 0)
)

server <- function(input, output){

  observeEvent(input$theId, {
    print(input$theId)
  })

}

if(interactive())
  shinyApp(ui, server)
```

No code was written, yet we have a fully-functional input! We'll leave ir at this: it's not only meant to create increment buttons, but this sets up a solid base for the developer to customise the code and conveniently create a different input.

It is worth noting that we built a Shiny input from within a package, this is meant to be exported\index{export} and used in Shiny applications elsewhere, but were one to run these same steps from a golem application packer would adapt the output path so that the input can be used directly in the application.
