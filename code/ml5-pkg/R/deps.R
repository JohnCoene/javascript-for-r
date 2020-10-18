#' @export
useMl5 <- function(cdn = TRUE) {

  pkg <- htmltools::htmlDependency(
    name = "ml5-pkg",
    version = "1.0.0",
    src = "",
    script = c(file = "classify.js"),
    package = "ml5"
  )

  ml5 <- list()
  if(cdn)
    ml5 <- htmltools::htmlDependency(
      name = "ml5",
      version = "0.4.3",
      src = c(href = "https://unpkg.com/ml5@0.4.3/dist/"),
      script = "ml5.min.js"
    )
  else 
    ml5 <- htmltools::htmlDependency(
      name = "ml5",
      version = "0.4.3",
      src = "",
      script = c(file = "ml5.min.js"),
      package = "ml5"
    )

  htmltools::tagList(ml5, pkg)
}