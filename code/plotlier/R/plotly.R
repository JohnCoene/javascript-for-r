#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
plotly <- function(data, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    data = data,
    options = list()
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'plotly',
    x,
    width = width,
    height = height,
    package = 'plotlier',
    elementId = elementId,
    preRenderHook = render_plotlier,
    sizingPolicy = sizingPolicy(
      defaultWidth = "100%"
    )
  )
}

render_plotlier <- function(p){
  p$x$data <- NULL
  return(p)
}

#' Shiny bindings for plotly
#'
#' Output and render functions for using plotly within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a plotly
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name plotly-shiny
#'
#' @export
plotlyOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'plotly', width, height, package = 'plotlier')
}

#' @rdname plotly-shiny
#' @export
renderPlotly <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, plotlyOutput, env, quoted = TRUE)
}

#' @rdname plotly-shiny
#' @export
plotlyProxy <- function(id, session = shiny::getDefaultReactiveDomain()){
  list(
    id = id,
    session = session
  )
}