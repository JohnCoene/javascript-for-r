# Progress Bar {#progress}

In this chapter we implement a loading bar via [Rsup-progress](https://github.com/skt-t1-byungi/rsup-progress) that can be programmatically triggered from the server. The library can be customised to great lengths but the code remains very straightforward for simple use cases.

```js
// initialise
const progress = new RsupProgress();

// customise
progress.setOptions({color: 'blue'});

// start
progress.start();

// end
progress.end();
```

## R Code {#progress-r-code}

Rsup-progress is hosted on a CDN so the dependency does not need to be downloaded, a file to hold the custom message handlers is however necessary.  

```r
dir.create("www")
file.create("www/script.js")
```

We then create the skeleton of the application, leaving the sever function empty for now. 

```r
library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://unpkg.com/rsup-progress"),
    tags$script(src = "www/script.js")
  ),
  br(),
  actionButton("start", "start"),
  actionButton("end", "end")
)

server <- function(input, output, session){

}

shinyApp(ui, server)
```

Then one can start designing the server; the buttons have to start/show and end/hide the loading bar. We also want to include a call to customise the loading bar from the server.

```r
library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://unpkg.com/rsup-progress"),
    tags$script(src = "www/script.js")
  ),
  br(),
  actionButton("start", "start"),
  actionButton("end", "end")
)

server <- function(input, output, session){

  session$sendCustomMessage('rsup-options', list(color = "red"))

  observeEvent(input$start, {
    session$sendCustomMessage('rsup-start', list())
  })

  observeEvent(input$end, {
    session$sendCustomMessage('rsup-end', list())
  })

}

shinyApp(ui, server)
```

## JavaScript Code {#progress-js-code}

Before one can implement the JavaScript message handlers, the progress bar needs to be initialised

```js
// script.js
const progress = new RsupProgress();
```

The message handlers themselves are rather bare since only the `setOptions` method takes arguments.

```js
// script.js
const progress = new RsupProgress();

Shiny.addCustomMessageHandler('rsup-options', function(msg){
  progress.setOptions(msg);
});

Shiny.addCustomMessageHandler('rsup-start', function(msg){
  progress.start();
});

Shiny.addCustomMessageHandler('rsup-end', function(msg){
  progress.end();
});
```

![Example of Rsup-progress in shiny](images/rsup.png)

Then again, there are many more options and methods that we do not implement here but would make for a great exercise and even a great R package. 

## Events {#progress-events}

The way rsup is set up is interesting in that the loading bar is shown or hidden from the R server. One could set it up differently however. Perhaps, instead of having to trigger the loading bar from the server it could all be handled automatically: showing the bar when the server is computing or redrawing things and hiding it when the server becomes idle again. 

```r
file.create("www/auto.js")
```

Below we declare the progress variable that will hold the Rsup-progress object. This is declared before it is created as this object needs to be accessible in various contexts.

```js
// auto.js
var progress;
```

We can then observe for the `shiny:busy` and `shiny:idle` events to show and hide the progress bar automatically.

```js
// auto.js
var progress;

$(document).on('shiny:busy', function(event){
  progress = new RsupProgress();
  progress.start();
});

$(document).on('shiny:idle', function(event){
  progress.end();
});
```

With that done one can test that it works by placing `auto.js` in an application.

```r
library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://unpkg.com/rsup-progress"),
    tags$script(src = "www/auto.js")
  ),
  br(),
  actionButton("render", "render"),
  plotOutput("plot")
)

server <- function(input, output){

  output$plot <- renderPlot({
    input$render
    Sys.sleep(2)
    hist(rnorm(100))
  })

}

shinyApp(ui, server)
```
