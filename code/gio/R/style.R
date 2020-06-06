#' @export
gio_style <- function(g, style = "magic"){
  g$x$style <- style
  return(g)
}