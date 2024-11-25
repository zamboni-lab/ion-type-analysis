#' Import dirs
#'
#' @param dirs
#' @param fun
#' @param columns
#'
#' @return
#'
#' @examples
import_dirs <- function(dirs, fun, columns) {
  purrr::map(paste(unlist(dirs)), .f = list.files, full.names = TRUE) |>
    purrr::flatten() |>
    purrr::map(\(x) fun(file = x, columns = columns)) |>
    tidytable::bind_rows(.id = TRUE) |>
    tidytable::mutate(
      ms1_common_percent = fragment / ms1,
      msn_common_percent = fragment / msn,
      fragmented_percent = fragmented / ms1
    )
}
