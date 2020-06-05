.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "lena-assets",
    system.file("assets", package = "lena")
  )
}
