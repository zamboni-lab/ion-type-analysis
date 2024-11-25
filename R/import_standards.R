#' Import dirs
#'
#' @include reformat_table.R
#'
#' @param file
#' @param columns
#' @param score_min
#' @param remove_above
#' @param diff_min
#' @param diffs_to_keep
#' @param fragments_to_exclude
#'
#' @return
#'
#' @examples
import_standards <- function(file,
                             columns,
                             score_min = 0.7,
                             remove_above = TRUE,
                             diff_min = -4.5,
                             diffs_to_keep = list(c(-4.03, -3.99), c(-2.03, -1.99)),
                             fragments_to_exclude = list(c(143.70, 143.74), c(173.50, 173.54))) {
  table <- tidytable::fread(file)
  table_2 <- table |>
    reformat_table(
      file = file,
      remove_above = remove_above,
      diff_min = diff_min
    ) |>
    tidytable::filter(msn_row != 0) |>
    tidytable::filter(compound_annotation_score >= score_min)
}
