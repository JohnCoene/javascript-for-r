.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "jbox-assets",
    system.file("assets", package = "jbox")
  )
}
