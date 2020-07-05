counter <- new.env(parent = emptyenv())
counter$regressions <- 0

#' @export 
ml_simple_lm <- function(y, x){
  counter$regressions <- counter$regressions + 1

  # assign variables
  ml$assign("x", x)
  ml$assign("y", y)

  # address
  address <- paste0("regressions['", counter$regressions, "']")

  # create regression
  code <- paste0(address, " = new ML.SimpleLinearRegression(x, y);")
  ml$eval(code)
  regression <- ml$get(address)
  regression$address <- address

  structure(regression, class = c("mlSimpleRegression", class(regression)))
}

#' @export
ml_predict <- function(x){
  ml$call("regression.predict", newdata)
}

#' @export 
predict.mlSimpleRegression <- function(object, newdata, ...){
  code <- paste0(object$address, ".predict")
  ml$call(code, newdata)
}