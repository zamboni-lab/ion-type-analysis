#' Add sample
#'
#' @param x
#'
#' @return
#'
#' @examples
add_sample <- function(x) {
  return(c(y = max(x) + .025, label = length(x)))
}
