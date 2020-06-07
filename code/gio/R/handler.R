# reshape input data
related_countries_handler <- function(x, session, inputname){
  purrr::map_dfr(x, as.data.frame)
}