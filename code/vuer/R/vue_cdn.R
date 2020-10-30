#' Dependencies for Vue
#' 
#' Includes Vue dependencies in a shiny application.
#' 
#' @param version Version of Vue to use, if `NULL` uses the latest
#' 
#' @keywords internal
vueCDN <- function(version = NULL){

  version_string <- ".js"
  if(!is.null(version))
    version_string <- sprintf("@%d", version)

  vue <- sprintf("https://cdn.jsdelivr.net/npm/vue", version_string)
  shiny::singleton(
    shiny::tags$head(
      shiny::tags$script(src = vue, crossorigin = NA)
    )
  )
}
