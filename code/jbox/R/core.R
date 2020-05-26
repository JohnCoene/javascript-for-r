#' Create an Alert
#' @export
send_alert <- function(content = "alert", color = "blue", session = shiny::getDefaultReactiveDomain()){
  # define notice options
  notice = list(content = content, color = "black")

  # send the notice
  session$sendCustomMessage(type = "send-alert", message = notice)
}