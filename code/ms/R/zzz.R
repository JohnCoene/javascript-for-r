# zzz.R
ms <- NULL

.onLoad <- function(libname, pkgname){
  ms <<- V8::v8()

  dep <- system.file("ms.js", package = "ms")
  ms$source(dep)
}

.onUnload <- function(libpath){
  ms$reset()
}