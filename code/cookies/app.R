library(shiny)

addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(
      src = "https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"
    ),
    tags$script(src = "www/script.js")
  ),
  textInput("name_set", "What is your name?"),
  actionButton("save", "Save cookie"),
  actionButton("remove", "remove cookie"),
  uiOutput("name_get")
)

server <- function(input, output, session){

  # save
  observeEvent(input$save, {
    if(input$name_set != "")
      session$sendCustomMessage("cookie-set", list(name = "name", value = input$name_set))
  })

  # delete
  observeEvent(input$remove, {
    session$sendCustomMessage("cookie-remove", list(name = "name"))
  })

  # output if cookie is specified
  output$name_get <- renderUI({
    if(!is.null(input$cookies$name))
      h3("Hello,", input$cookies$name)
    else
      h3("Who are you?")
  })

}

shinyApp(ui, server)