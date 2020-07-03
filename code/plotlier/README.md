
# plotlier

Example of htmlwidgets for plotly.js

## Example

use in shiny

``` r
library(shiny)
library(plotlier)

df <- data.frame(x = 1:10, y = runif(10))

ui <- fluidPage(
  actionButton("add", "Add random trace"),
  plotlyOutput("plot")
)

server <- function(input, output){

  output$plot <- renderPlotly({
    df %>% 
      plotly() %>% 
      plot_line("x", "y")
  })

  proxy <- plotlyProxy("plot")

  observeEvent(input$add, {
    random <- data.frame(x = runif(10, 1, 10), y = runif(10))
    
    plot_add_line(
      proxy,
      random,
      "x", "y"
    )
  })

}

shinyApp(ui, server)
```

