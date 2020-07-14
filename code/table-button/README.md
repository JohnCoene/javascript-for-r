# Table Buttons

Example of using JavaScript to include buttons in a shiny table (DT).

```r
library(DT)
library(shiny)

ui <- fluidPage(
  DTOutput("table"),
  strong("Clicked Model:"),
  verbatimTextOutput("model")
)

server <- function(input, output) {
  output$table <- renderDT({
    onclick <- paste0("Shiny.setInputValue('click', '", rownames(mtcars), "')")
    button <- paste0("<a class='btn btn-primary' onClick=\"", onclick, "\">Click me</a>")
    mtcars$button <- button
    datatable(mtcars, escape = FALSE, selection = "none", rownames = FALSE)
  })

  output$model <- renderPrint({
    print(input$click)
  })
}

shinyApp(ui, server)
```
