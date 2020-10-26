#' increment
#' 
#' Incremental button.
#' 
#' @param inputId Id of input.
#' @param value Initial value.
#' 
#' @examples 
#' library(shiny)
#' 
#' ui <- fluidPage(
#'  incrementInput("theId", 0)
#' )
#' 
#' server <- function(input, output){
#' 
#'  observeEvent(input$theId, {
#'    print(input$theId)
#'  })
#' 
#' }
#' 
#' if(interactive())
#'  shinyApp(ui, server)
#' 
#' @importFrom shiny tags tagList
#' 
#' @export 
incrementInput <- function(inputId, value = 0){

  stopifnot(!missing(inputId))
  stopifnot(is.numeric(value))

  dep <- htmltools::htmlDependency(
    name = "incrementBinding",
    version = "1.0.0",
    src = c(file = system.file("packer", package = "increment")),
    script = "increment.js"
  )

  tagList(
    dep,
    tags$button(
      id = inputId,
      class = "incrementBinding btn btn-default",
      type = "button",
      value
    )
  )
}
