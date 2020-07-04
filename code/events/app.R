library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$link(href = "www/style.css", rel = "stylesheet"),
  tags$script(src = "www/script.js"),
  h1("What color am I?", id = "color"),
  tags$img(src = "www/typing.gif", id = "loading"),
  plotOutput("plot"),
  actionButton("render", "render")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    input$render
    Sys.sleep(2)
    plot(cars)
  })
}

shinyApp(ui, server)
