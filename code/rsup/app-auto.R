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
