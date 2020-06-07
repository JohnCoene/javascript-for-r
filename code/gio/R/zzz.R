# R/zzz.R
.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("gio.related.countries", related_countries_handler, force = TRUE)
}