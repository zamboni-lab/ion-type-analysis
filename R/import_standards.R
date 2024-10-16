#' Import dirs
#'
#' @param file
#' @param columns
#'
#' @return
#' @export
#'
#' @examples
import_standards <- function(file, columns) {
  tidytable::fread(file) |>
    tidytable::select(tidytable::any_of(columns)) |>
    tidytable::bind_rows(
      columns |>
        data.frame() |>
        t() |>
        tidytable::as_tidytable() |>
        dplyr::mutate_all(
          .funs = function(x) {
            NA
          }
        )
    ) |>
    tidytable::filter(!is.na(ms1)) |>
    tidytable::filter(!is.na(smiles)) |>
    # tidytable::group_by(smiles) |>
    tidytable::filter(area == max(area)) |>
    tidytable::filter(ms1 == max(ms1)) |>
    # tidytable::ungroup() |>
    tidytable::mutate(filename = file, cutoff = basename(dirname(file)))
}
