#' @export
gio_proxy <- function(id, session = shiny::getDefaultReactiveDomain()){
  list(id = id, session = session)
}

#' @export
gio_send_data <- function(proxy, data){
  message <- list(id = proxy$id, data = apply(data, 1, as.list))
  proxy$session$sendCustomMessage("send-data", message)
  return(proxy)
}

#' @export
gio_clear_data <- function(proxy){
  message <- list(id = proxy$id)
  proxy$session$sendCustomMessage("clear-data", message)
  return(proxy)
}