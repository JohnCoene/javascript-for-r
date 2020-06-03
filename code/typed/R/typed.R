#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
typed <- function(message, loop = FALSE, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    loop = loop,
    strings = as.list(message)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'typed',
    x,
    width = width,
    height = height,
    package = 'typed',
    elementId = elementId
  )
}

typed_html <- function(...){
  htmltools::tags$span(...)
}

#' Shiny bindings for typed
#'
#' Output and render functions for using typed within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a typed
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name typed-shiny
#'
#' @export
typedOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'typed', width, height, package = 'typed')
}

#' @rdname typed-shiny
#' @export
renderTyped <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, typedOutput, env, quoted = TRUE)
}
