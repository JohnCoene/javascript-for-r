library("shiny")

addResourcePath("www", "www")

handler <- function(data, ...){
  purrr::map_dfr(data, as.data.frame)
}

shiny::registerInputHandler("class", handler, force = TRUE)

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://unpkg.com/ml5@0.4.3/dist/ml5.min.js"),
    tags$script(src = "www/classify.js")
  ),
  fluidRow(
    column(
      2,
      selectInput(
        "select", "Select an image to classify",
        choices = c("gentoo", "fratercula", "hummingbird", "flamingo")
      )
    ),
    column(
      2, br(), actionButton("classify", "Classify", icon = icon("search"))
    )
  ),
  uiOutput("img"),
  tableOutput("results")
)

server <- function(input, output, session){

  output$img <- renderUI({
    path <- paste0("www/", input$select, ".jpg")
    tags$img(src = path, id = "bird")
  })

  observeEvent(input$classify, {
    session$sendCustomMessage('classify', list())
  })

  output$results <- renderTable({
    input$classification
  })

}

shinyApp(ui, server)