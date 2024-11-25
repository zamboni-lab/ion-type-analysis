#' Export figure
#'
#' @param figure
#' @param filename
#' @param extension
#' @param height
#' @param width
#'
#' @return
#'
#' @examples
export_figure <- function(figure,
                          filename,
                          extension = EXTENSION,
                          height = 7,
                          width = 7) {
  path <- paste(filename, extension, sep = ".")
  if (extension == "png") {
    ggplot2::ggsave(figure,
      filename = path,
      height = height,
      width = width
    )
  } else {
    ggpubr::ggexport(figure,
      filename = path,
      height = height,
      width = width
    )
  }
}
