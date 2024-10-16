#' Import dirs
#'
#' @param dirs
#' @param fun
#' @param columns
#'
#' @return
#' @export
#'
#' @examples
import_dirs <- function(dirs, fun, columns) {
  purrr::map(paste(unlist(dirs)), .f = list.files, full.names = TRUE) |>
    purrr::flatten() |>
    purrr::map(\(x) fun(file = x, columns = columns)) |>
    tidytable::bind_rows() |>
    tidytable::mutate(
      ms1_common_percent = fragments / ms1,
      ms2_common_percent = fragments / ms2,
      fragmented_percent = fragmented / ms1
    )
}
