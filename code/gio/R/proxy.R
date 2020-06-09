#' @export
gio_send_data <- function(id, data, session = shiny::getDefaultReactiveDomain()){
  message <- list(id = id, data = apply(data, 1, as.list))
  session$sendCustomMessage("send-data", message)
}