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
gio_send_style <- function(proxy, style){
  message <- list(id = proxy$id, style = style)
  proxy$session$sendCustomMessage("send-style", message)
  return(proxy)
}