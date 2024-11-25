#' Create intensities df
#'
#' @param df_intensities_ot
#' @param df_intensities_tof
#'
#' @return
#'
#' @examples
create_intensities_df <- function(df_intensities_ot, df_intensities_tof) {
  ot_1 <- df_intensities_ot |>
    tidytable::filter(!is.na(highest_fragment_intensity)) |>
    tidytable::distinct(smiles, .keep_all = TRUE) |>
    tidytable::mutate(ratio = highest_fragment_intensity / height) |>
    tidytable::arrange(ratio) |>
    tidytable::mutate(type = "OT (1ˢᵗ)")
  ot_2 <- df_intensities_ot |>
    tidytable::filter(!is.na(second_fragment_intensity)) |>
    tidytable::distinct(smiles, .keep_all = TRUE) |>
    tidytable::mutate(ratio = second_fragment_intensity / height) |>
    tidytable::arrange(ratio) |>
    tidytable::mutate(type = "OT (2ⁿᵈ)")
  ot_3 <- df_intensities_ot |>
    tidytable::filter(!is.na(third_fragment_intensity)) |>
    tidytable::distinct(smiles, .keep_all = TRUE) |>
    tidytable::mutate(ratio = third_fragment_intensity / height) |>
    tidytable::arrange(ratio) |>
    tidytable::mutate(type = "OT (3ʳᵈ)")
  tof_1 <- df_intensities_tof |>
    tidytable::filter(!is.na(highest_fragment_intensity)) |>
    tidytable::distinct(smiles, .keep_all = TRUE) |>
    tidytable::mutate(ratio = highest_fragment_intensity / height) |>
    tidytable::arrange(ratio) |>
    tidytable::mutate(type = "ToF (1ˢᵗ)")
  tof_2 <- df_intensities_tof |>
    tidytable::filter(!is.na(second_fragment_intensity)) |>
    tidytable::distinct(smiles, .keep_all = TRUE) |>
    tidytable::mutate(ratio = second_fragment_intensity / height) |>
    tidytable::arrange(ratio) |>
    tidytable::mutate(type = "ToF (2ⁿᵈ)")
  tof_3 <- df_intensities_tof |>
    tidytable::filter(!is.na(third_fragment_intensity)) |>
    tidytable::distinct(smiles, .keep_all = TRUE) |>
    tidytable::mutate(ratio = third_fragment_intensity / height) |>
    tidytable::arrange(ratio) |>
    tidytable::mutate(type = "ToF (3ʳᵈ)")

  df_intensities <- ot_1 |>
    tidytable::bind_rows(ot_2) |>
    tidytable::bind_rows(ot_3) |>
    tidytable::bind_rows(tof_1) |>
    tidytable::bind_rows(tof_2) |>
    tidytable::bind_rows(tof_3)
  return(df_intensities)
}
