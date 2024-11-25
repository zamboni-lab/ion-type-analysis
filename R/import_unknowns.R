#' Import dirs
#'
#' @include reformat_table.R
#' @include select_intervals.R
#'
#' @param file
#' @param columns
#' @param remove_above
#' @param diff_min
#' @param diffs_to_keep
#' @param fragments_to_exclude
#' @param invert_selection
#' @param fragmented_intensity_min
#'
#' @return
#'
#' @examples
import_unknowns <- function(file,
                            columns,
                            remove_above = TRUE,
                            diff_min = -4.5,
                            diffs_to_keep = list(c(-4.03, -3.99), c(-2.03, -1.99)),
                            fragments_to_exclude = list(c(143.70, 143.74), c(173.50, 173.54)),
                            fragmented_intensity_min = 0.5) {
  table <- tidytable::fread(file)

  table_2 <- table |>
    reformat_table(
      file = file,
      remove_above = remove_above,
      diff_min = diff_min
    ) |>
    tidytable::filter(msn != 0) |>
    tidytable::filter(!is.na(`rt_range:max`)) |>
    tidytable::mutate(fragmented_percent = fragmented / ms1) |>
    tidytable::filter(percent_fragmented_intensity >= fragmented_intensity_min) |>
    tidytable::arrange(tidytable::desc(percent_fragmented_intensity)) |>
    tidytable::arrange(`rt_range:max`) |>
    select_intervals() |>
    tidytable::bind_rows() |>
    tidytable::mutate(filename = file, cutoff = basename(dirname(file)))
}
