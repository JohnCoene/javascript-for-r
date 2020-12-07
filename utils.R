include_widget <- function(w, img_path) {
  if (knitr::is_latex_output()) {
    img <- paste0("images/", img_path)
    knitr::include_graphics(img)
  } else {
    w
  }
}