<!-- badges: start -->
<!-- badges: end -->

# lena

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(lena)
library(shiny)

ui <- fluidPage(
  testImage(id = "toFilter"),
  lenaOutput("filtered")
)

server <- function(input, output){

  output$filtered <- renderLena({
    lena("toFilter", "roberts")
  })

}

shinyApp(ui, server)
```

