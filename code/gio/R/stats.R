#' @export
gio_stats <- function(g){
  # add dependency
  path <- system.file("htmlwidgets/stats", package = "gio")
  dep <- htmltools::htmlDependency(
    name = "stats",
    version = "17",
    src = c(file = path),
    script = "stats.min.js"
  )

  g$dependencies <- append(g$dependencies, list(dep))

  g$x$stats <- TRUE

  return(g)
}