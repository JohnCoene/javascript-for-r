# zzz.R
ml <- NULL

.onLoad <- function(libname, pkgname){
  ml <<- V8::v8()
  mljs <- system.file("ml.min.js", package = "ml")
  ml$source(mljs)

  # array to track regression
  ml$eval("var regressions = [];")
}