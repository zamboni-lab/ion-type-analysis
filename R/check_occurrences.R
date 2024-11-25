#' Check occurrences
#'
#' @include plot_bins.R
#'
#' @param df_standards_full
#'
#' @return
#'
#' @examples
check_occurrences <- function(df_standards_full) {
  df_bins_tof <- df_standards_full |>
    tidytable::filter(grepl(
      pattern = "di_tof",
      x = cutoff,
      fixed = TRUE
    )) |>
    tidytable::filter(grepl(
      pattern = "[M+H]+",
      x = adduct_type,
      fixed = TRUE
    ))

  df_bins_ot <- df_standards_full |>
    tidytable::filter(grepl(
      pattern = "di_ot",
      x = cutoff,
      fixed = TRUE
    )) |>
    tidytable::filter(grepl(
      pattern = "[M+H]+",
      x = adduct_type,
      fixed = TRUE
    ))

  ints_tof <- df_bins_tof$percent_fragments_intensity_broad |>
    as.numeric() |>
    sort()
  median(ints_tof, na.rm = TRUE)

  ints_ot <- df_bins_ot$percent_fragments_intensity_broad |>
    as.numeric() |>
    sort()
  median(ints_ot, na.rm = TRUE)

  diffs_new_tof <- df_bins_tof$common_diffs_row |>
    purrr::flatten() |>
    as.numeric()
  mzs_new_tof <- df_bins_tof$common_mzs_row |>
    purrr::flatten() |>
    as.numeric()

  diffs_new_ot <- df_bins_ot$common_diffs_row |>
    purrr::flatten() |>
    as.numeric()
  mzs_new_ot <- df_bins_ot$common_mzs_row |>
    purrr::flatten() |>
    as.numeric()

  losses_tof <- plot_bins(
    mzs = diffs_new_tof,
    min_mz = -500.5,
    max_mz = 50.5,
    threshold = 1750,
    y_max = 4550,
    title = "common losses - ToF"
  )
  fragments_tof <- plot_bins(
    mzs = mzs_new_tof,
    min_mz = 50.5,
    max_mz = 600.5,
    threshold = 2000,
    y_max = 6500,
    title = "common fragments - ToF"
  )
  losses_ot <- plot_bins(
    mzs = diffs_new_ot,
    min_mz = -500.5,
    max_mz = 50.5,
    threshold = 500,
    y_max = 2750,
    title = "common losses - OT"
  )
  fragments_ot <- plot_bins(
    mzs = mzs_new_ot,
    min_mz = 50.5,
    max_mz = 600.5,
    threshold = 1000,
    y_max = 2000,
    title = "common fragments - OT"
  )
  # fragments_ot_2 <- plot_bins(
  #   mzs = mzs_new_ot,
  #   min_mz = 50.5,
  #   max_mz = 600.5,
  #   threshold = 1000,
  #   y_max = 2000,
  #   title = "common fragments - OT excluding 174"
  # )
  return(
    list(
      "fragments_ot" = fragments_ot,
      "fragments_tof" = fragments_tof,
      "losses_ot" = losses_ot,
      "losses_tof" = losses_tof
    )
  )
}
