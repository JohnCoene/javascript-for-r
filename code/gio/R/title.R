#' @export
gio_title <- function(g, title){
  title <- htmltools::h3(title)
  htmlwidgets::prependContent(g, title)
}