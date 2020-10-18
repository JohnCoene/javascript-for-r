library(shiny)

# serve images
addResourcePath("assets", "assets")

# create handler
handler <- function(data, ...){
  purrr::map_dfr(data, as.data.frame)
}

# register with shiny
shiny::registerInputHandler("ml5.class", handler)

# ml5js dependency
dependency_ml5 <- htmltools::htmlDependency(
  name = "ml5",
  version = "0.4.3",
  src = c(href = "https://unpkg.com/ml5@0.4.3/dist/"),
  script = "ml5.min.js"
)

ui <- fluidPage(
  dependency_ml5,
  tags$head(tags$script(src = "assets/classify.js")),
  selectInput(
    inputId = "selectedBird", 
    label = "bird",
    choices = c("flamingo", "lorikeet")
  ),
  actionButton("classify", "Classify"),
  uiOutput("birdDisplay"),
  tableOutput("results")
)

server <- function(input, output, session) {

  output$birdDisplay <- renderUI({
    path <- sprintf("assets/%s.jpg", input$selectedBird)
    tags$img(src = path, id = "bird")
  })

  observeEvent(input$classify, {
    session$sendCustomMessage("classify", list())
  })

  output$results <- renderTable({
    input$classification
  })

}

shinyApp(ui, server)
