<!-- badges: start -->
<!-- badges: end -->

# jbox

An example of integrating JavaScript with shiny as a package.

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/r-and-javascript/code/jbox")
```

## Example

``` r
library(jbox)
library(shiny)

ui <- fluidPage(
  usejBox(),
  verbatimTextOutput("callback")
)

server <- function(input, output){
  send_alert("myid", "Hello from the server!")

  output$callback <- renderPrint({
    paste("Is the alert closed: ", input$myid_alert_close)
  })
}

shinyApp(ui, server)
```

