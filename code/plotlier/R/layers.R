#' @export
plot_line <- function(p, x, y){
  add_scatter(p, x, y, mode = "lines")
}

#' @export
plot_marker <- function(p, x, y){
  add_scatter(p, x, y, mode = "markers")
}

add_scatter <- function(p, x, y, mode = "markers"){
  layer <- list(
    x = dplyr::pull(p$x$data, {{ x }}),
    y = dplyr::pull(p$x$data, {{ y }}),
    type = "scatter",
    mode = mode
  )

  p$x$options <- append(p$x$options, list(layer))
  return(p)
}