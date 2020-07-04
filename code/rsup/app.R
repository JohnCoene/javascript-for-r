library(shiny)

shiny::addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://unpkg.com/rsup-progress"),
    tags$script(src = "www/script.js")
  ),
  br(),
  actionButton("start", "start"),
  actionButton("end", "end")
)

server <- function(input, output, session){

  session$sendCustomMessage('rsup-options', list(color = "red"))

  observeEvent(input$start, {
    session$sendCustomMessage('rsup-start', list())
  })

  observeEvent(input$end, {
    session$sendCustomMessage('rsup-end', list())
  })

}

shinyApp(ui, server)
