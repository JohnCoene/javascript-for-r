library(DT)
library(ml5)
library(shiny)

addResourcePath("assets", "assets")

ui <- fluidPage(
  useMl5(),
  selectInput(
    inputId = "selectedBird", 
    label = "bird",
    choices = c("flamingo", "lorikeet")
  ),
  actionButton("classify", "Classify"),
  uiOutput("birdDisplay"),
  DTOutput("results")
)

server <- function(input, output, session) {

  output$birdDisplay <- renderUI({
    path <- sprintf("assets/%s.jpg", input$selectedBird)
    tags$img(src = path, id = "bird")
  })

  observeEvent(input$classify, {
    classify("bird")
  })

  output$results <- renderDT({
    datatable(input$bird_classification)
  })

}

shinyApp(ui, server)