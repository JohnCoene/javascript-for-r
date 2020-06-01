#' Convert To Millisecond
#' 
#' Convert to milliseconds to various formats.
#' 
#' @param string String to convert.
#' 
#' @export
to_ms <- function(string){
  ms$call("ms", string)
}