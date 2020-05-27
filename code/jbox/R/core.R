#' Create an Alert
#' @export
send_alert <- function(id, content = "alert", color = "blue", session = shiny::getDefaultReactiveDomain()){
  # define notice options
  notice = list(content = content, color = "black")

  # add id
  message <- list(id = id, notice = notice)

  # send the notice
  session$sendCustomMessage(type = "send-alert", message = message)
}