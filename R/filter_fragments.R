#' Filter fragments
#'
#' @param fragments
#' @param diffs
#' @param diff_min
#' @param diffs_to_keep
#' @param fragments_to_exclude
#' @param invert_selection
#'
#' @return
#'
#' @examples
filter_fragments <- function(fragments,
                             diffs,
                             diff_min = -4.5,
                             diffs_to_keep = list(c(-4.03, -3.99), c(-2.03, -1.99)),
                             fragments_to_exclude = list(c(143.70, 143.74), c(173.50, 173.54)),
                             invert_selection = FALSE) {
  indices <- diffs[diffs <= diff_min]

  keep_indices <- tidytable::map_lgl(diffs, function(value) {
    any(tidytable::map_lgl(diffs_to_keep, ~ value >= .x[1] &&
      value <= .x[2]))
  })

  exclude_indices <- tidytable::map_lgl(fragments, function(value) {
    any(tidytable::map_lgl(fragments_to_exclude, ~ value >= .x[1] &&
      value <= .x[2]))
  })

  final_indices <- (indices | keep_indices) & !exclude_indices

  if (invert_selection) {
    final_indices <- !final_indices
  }

  fragments[final_indices]
}
