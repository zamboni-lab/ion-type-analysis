#' Import dirs
#'
#' @param file
#' @param columns
#'
#' @return
#' @export
#'
#' @examples
import_unknowns <- function(file, columns) {
  tidytable::fread(file) |>
    tidytable::select(tidytable::any_of(columns)) |>
    tidytable::filter(!is.na(rt_max)) |>
    tidytable::arrange(tidytable::desc(area)) |>
    tidytable::arrange(rt_max) |>
    select_intervals() |>
    tidytable::bind_rows() |>
    tidytable::mutate(filename = file, cutoff = basename(dirname(file)))
}
