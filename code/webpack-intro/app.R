library(shiny)

mainJs <- htmltools::htmlDependency(
  name = "main",
  version = "1.0.0",
  src = "./dist",
  script = c(file = "main.js")
)

ui <- fluidPage(
  mainJs,
  p("Type the secret phrase"),
  uiOutput("hello"),
  plotOutput("plot")
)

server <- function(input, output) {
  output$hello <- renderUI({
    req(input$secret)
    h2("You got the secret right!")
  })

  output$plot <- renderPlot({
    req(input$secret)
    hist(cars$speed)
  })
}

shinyApp(ui, server)

