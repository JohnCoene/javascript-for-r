library(lena)
library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$img(src = "www/r-logo.png", id = "toFilter"),
  lenaOutput("filtered")
)

server <- function(input, output){

  output$filtered <- renderLena({
    lena("toFilter", "roberts")
  })

}

shinyApp(ui, server)