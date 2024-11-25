#' Choose pal
#'
#' @param subclasses
#'
#' @return
#'
#' @examples
choose_pal <- function(subclasses) {
  pal <- if (subclasses <= 10) {
    color <- ggsci::pal_npg()
    rev(color(subclasses))
  } else {
    tableau20 <- c(
      "#4E79A7",
      "#A0CBE8",
      "#F28E2B",
      "#FFBE7D",
      "#59A14F",
      "#8CD17D",
      "#B6992D",
      "#F1CE63",
      "#499894",
      "#86BCB6",
      "#E15759",
      "#FF9D9A",
      "#79706E",
      "#BAB0AC",
      "#D37295",
      "#FABFD2",
      "#B07AA1",
      "#D4A6C8",
      "#9D7660",
      "#D7B5A6"
    )[1:subclasses]
  }
  return(pal)
}
