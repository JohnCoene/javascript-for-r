# create handler
handler <- function(data, ...){
  purrr::map_dfr(data, as.data.frame)
}

# register with shiny
.onLoad <- function(...){
  shiny::registerInputHandler("ml5.class", handler)
}