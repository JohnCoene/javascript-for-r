library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$link(href = "www/style.css", rel = "stylesheet"),
    tags$script(src = "www/script.js")
  ),
  tags$img(src = "www/typing.gif", id = "loading"),
  plotOutput("plot"),
  actionButton("render", "render")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    input$render
    Sys.sleep(10)
    plot(cars)
  })
}

shinyApp(ui, server)
