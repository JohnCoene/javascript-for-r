#' @export
plot_add_marker <- function(proxy, data, x, y){
  data <- list(
    x = data[[x]],
    y = data[[y]],
    type = "scatter",
    mode = "markers"
  )

  msg <- list(id = proxy$id, data = data)
  proxy$session$sendCustomMessage("add-traces", msg)
  return(proxy)
}