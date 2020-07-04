library(shiny)

addResourcePath("assets", "assets")

ui <- fluidPage(
  tags$link(href = "assets/mprogress.min.css", rel = "stylesheet"),
  tags$script(src = "assets/mprogress.min.js"),
  tags$script(src = "assets/custom.js"),
  actionButton("show", "Show"),
  actionButton("hide", "Hide")
)

server <- function(input, output, session){

  session$sendCustomMessage('mprogress-init', list(template =  3))

  observeEvent(input$show, {
    session$sendCustomMessage('mprogress-start', list())
  })

  observeEvent(input$hide, {
    session$sendCustomMessage('mprogress-end', list())
  })

}

shinyApp(ui, server)