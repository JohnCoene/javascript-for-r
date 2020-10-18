library(shiny)

ui <- fluidPage(
  tags$head(
    tags$script(
      src = paste0(
        "https://cdn.jsdelivr.net/gh/StephanWagner/",
        "jBox@v1.2.0/dist/jBox.all.min.js"
      )
    ),
    tags$link(
      rel = "stylesheet",
      href = paste0(
        "https://cdn.jsdelivr.net/gh/StephanWagner/",
        "jBox@v1.2.0/dist/jBox.all.min.css"
      )
    ),
    tags$script(
      "Shiny.addCustomMessageHandler(
        type = 'send-notice', function(message) {
          message.onClose = function(){
            Shiny.setInputValue('notice_close', true, {priority: 'event'});
          }
          new jBox('Notice', message);
      });"
    )
  ),
  textInput("msg", "A message to show as notice"),
  actionButton("show", "Show the notice")
)

server <- function(input, output, session){

  observeEvent(input$show, {
    # define notice options
    notice = list(
      content = input$msg,
      color = 'black'
    )

    # send the notice
    session$sendCustomMessage(
      type = "send-notice", message = notice
    )
  })

  # print the output of the notice_close event (when fired)
  observeEvent(input$notice_close, {
    print(input$notice_close)
  })
}

shinyApp(ui, server)