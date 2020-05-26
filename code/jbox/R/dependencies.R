#' Import Dependencies
#' @export
usejBox <- function(){
  shiny::tags$head(
    shiny::tags$script(src = "jbox-assets/jBox.all.min.js"),
    shiny::tags$link(rel = "stylesheet", href = "jbox-assets/jBox.all.min.css"),
    shiny::tags$script(src = "jbox-assets/custom.js")
  )
}
