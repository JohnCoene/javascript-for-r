#' @export
lena <- function(img_id, filter = "red"){
  list(img_id = img_id, filter = filter)
}

#' @export
renderLena <- function(expr, env = parent.frame(), quoted = FALSE) {
  # Convert the expression + environment into a function
  func <- shiny::exprToFunction(expr, env, quoted)

  function(){
    func()
  }
}

#' @export
lenaOutput <- function(id){
  el <- shiny::tags$canvas(id = id, class = "lena")

  path <- system.file("assets", package = "lena")

  deps <- list(
    htmltools::htmlDependency(
      name = "lena",
      version = "1.0",
      src = c(file = path),
      script = c("lena.min.js", "custom.js")
    )
  )

  htmltools::attachDependencies(el, deps)

}
