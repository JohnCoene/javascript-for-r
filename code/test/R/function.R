#' @export
print_file <- function(){
  file <- system.file("javascript.js", package = "test")
  cli::cli_alert_info("JavaScript code below.")
  content <- readLines(file)
  print(content)
}