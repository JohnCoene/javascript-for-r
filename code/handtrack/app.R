library(shiny)

addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(src = "www/handtrack.min.js")
  ),
  fluidRow(
    column(4, tags$video(id = "webcam")),
    column(8, tags$canvas(id = "canvas", style = "width: 100%;height:500px;"))
  ),
  tags$script(src = "www/script.js")
)

server <- function(input, output, session){

  observeEvent(input$predictions, {
    print(input$predictions)
  })

}

shinyApp(ui, server)
