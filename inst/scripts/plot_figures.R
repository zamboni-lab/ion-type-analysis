start <- Sys.time()

args <- commandArgs(trailingOnly = TRUE)

if (!("pkgload" %in% installed.packages())) {
  install.packages(c("pkgload"))
}

## Load necessary dependencies
pkgload::load_all()
install_dependencies_1(dependencies = dependencies)
install_dependencies_2(dependencies = dependencies)

## Switch for example mode
if ("example=TRUE" %in% args) {
  message("Running the example mode")
  path_dirs_unknowns <- list(di_tof_pos = "data/example/di_tof_5_20ev_pos")
}

## Import
### Standards
if (!"example=TRUE" %in% args) {
  df_standards_full <- path_standards_full |>
    tidytable::fread() |>
    tidytable::mutate(tidytable::across(
      c("common_mzs_row", "common_diffs_row"),
      .fns = function(x) {
        x |>
          strsplit(split = ", ") |>
          lapply(as.numeric)
      }
    ))
  dark_smiles_processed <- path_smiles_processed |>
    tidytable::fread()
  df_standards <- df_standards_full |>
    tidytable::group_by(`.id`) |>
    tidytable::filter(area == max(area)) |>
    tidytable::filter(ms1 == max(ms1)) |>
    tidytable::ungroup()
  df_standards_full_2 <- df_standards_full |>
    # tidytable::arrange(tidytable::desc(msn_row)) |>
    tidytable::group_by(`.id`, smiles, adduct_type) |>
    tidytable::filter(area == max(area)) |>
    tidytable::filter(ms1 == max(ms1)) |>
    tidytable::ungroup()
  # df_classes <- load_compound_classes()
}

### Unknowns
df_unknowns <- path_dirs_unknowns |>
  import_dirs(fun = import_unknowns, columns = COLNAMES) |>
  tidytable::bind_rows() |>
  tidytable::distinct()

## Combining
if (!"example=TRUE" %in% args) {
  df_combined <- df_standards |>
    tidytable::bind_rows(df_unknowns) |>
    tidytable::mutate(tidytable::across(tidytable::where(is.list), as.character))
} else {
  df_combined <- df_unknowns
}

## Check fragments/losses occurrences
list_occurrences <- check_occurrences(df_standards_full)

## Check fragments intensities
df_intensities_ot <- df_standards_full |>
  tidytable::filter(adduct_type == "[M+H]+") |>
  tidytable::filter(grepl("ot", filename)) |>
  tidytable::filter(!is.na(highest_fragment_intensity)) |>
  tidytable::distinct(
    height,
    smiles,
    common_intensities_row_narrow,
    highest_fragment_intensity,
    second_fragment_intensity,
    third_fragment_intensity
  )
df_intensities_tof <- df_standards_full |>
  tidytable::filter(adduct_type == "[M+H]+") |>
  tidytable::filter(grepl("tof_5_20", filename)) |>
  tidytable::filter(!is.na(highest_fragment_intensity)) |>
  tidytable::distinct(
    height,
    smiles,
    common_intensities_row_narrow,
    highest_fragment_intensity,
    second_fragment_intensity,
    third_fragment_intensity
  )
df_intensities_ot_full <- df_standards_full |>
  tidytable::filter(grepl("ot", filename)) |>
  tidytable::filter(!grepl(pattern = "-", x = adduct_type, fixed = TRUE)) |>
  tidytable::filter(!is.na(highest_fragment_intensity)) |>
  tidytable::distinct(
    height,
    smiles,
    common_intensities_row_narrow,
    highest_fragment_intensity,
    second_fragment_intensity,
    third_fragment_intensity
  )
df_intensities_tof_full <- df_standards_full |>
  tidytable::filter(grepl("tof_5_20", filename)) |>
  tidytable::filter(!grepl(pattern = "-", x = adduct_type, fixed = TRUE)) |>
  tidytable::filter(!is.na(highest_fragment_intensity)) |>
  tidytable::distinct(
    height,
    smiles,
    common_intensities_row_narrow,
    highest_fragment_intensity,
    second_fragment_intensity,
    third_fragment_intensity
  )
df_intensities <- create_intensities_df(df_intensities_ot = df_intensities_ot, df_intensities_tof = df_intensities_tof)
df_intensities_full <- create_intensities_df(df_intensities_ot = df_intensities_ot_full, df_intensities_tof = df_intensities_tof_full)

df_intensities_2 <- df_intensities |>
  tidytable::inner_join(dark_smiles_processed) |>
  tidytable::filter(grepl(pattern = "OT", x = type, fixed = TRUE)) |>
  tidytable::mutate(type_2 = ifelse(test = num_OH > 2, yes = "more than 2 -OH", no = "2 -OH or less"))

df_intensities_3 <- df_intensities_full |>
  tidytable::inner_join(dark_smiles_processed) |>
  tidytable::filter(grepl(pattern = "OT", x = type, fixed = TRUE)) |>
  tidytable::mutate(type_2 = ifelse(test = num_OH > 2, yes = "more than 2 -OH", no = "2 -OH or less")) |>
  tidytable::filter(type != "OT (3ʳᵈ)")

df_intensities_4 <- df_intensities_3 |>
  tidytable::mutate(
    common_intensities_row_narrow = common_intensities_row_narrow |>
      gsub(
        pattern = "c(",
        replacement = "",
        fixed = TRUE
      ) |>
      gsub(
        pattern = ")",
        replacement = "",
        fixed = TRUE
      )
  ) |>
  tidytable::separate_longer_delim(common_intensities_row_narrow, delim = ", ") |>
  tidytable::mutate(ratio = common_intensities_row_narrow |>
    as.numeric() / height) |>
  tidytable::mutate(
    type = tidytable::case_when(
      common_intensities_row_narrow == highest_fragment_intensity ~ "OT (1ˢᵗ)",
      common_intensities_row_narrow == second_fragment_intensity ~ "OT (2ⁿᵈ)",
      common_intensities_row_narrow == third_fragment_intensity ~ "OT (3ʳᵈ)",
      TRUE ~ "other"
    )
  ) |>
  tidytable::distinct(smiles, highest_fragment_intensity, second_fragment_intensity, ratio, type_2) |>
  tidytable::mutate(type = "all fragments", type_3 = "all molecules")
df_intensities_5 <- df_intensities_4 |>
  tidytable::filter(type_2 == "more than 2 -OH") |>
  tidytable::bind_rows(df_intensities_4 |>
    tidytable::filter(type_2 != "more than 2 -OH") |>
    tidytable::mutate(type_2 = type_3)) |>
  tidytable::select(-type_3)

## Combining ot datasets and renaming
df_combined <- df_combined |>
  tidytable::mutate_rowwise(
    cutoff = stringi::stri_replace_all_regex(
      str = cutoff,
      pattern = gsub(
        pattern = "data/",
        replacement = "",
        x = c(
          path_dirs_standards |> unlist() |> unname(),
          path_dirs_unknowns |> unlist() |> unname()
        )
      ),
      replacement = c(names(path_dirs_standards), names(path_dirs_unknowns)),
      vectorise_all = FALSE
    )
  ) |>
  # tidytable::filter(fragmented_percent>= 0.25) |>
  tidytable::mutate(cutoff = gsub("(di_ot_neg)(.*)", "\\1", cutoff)) |>
  tidytable::mutate(cutoff = gsub("(di_ot_pos)(.*)", "\\1", cutoff))

## Pivoting and filtering spectra where at least 10% was fragmented
df_pivoted_before <- df_combined |>
  tidytable::filter(fragmented / ms1 >= 0.1) |>
  tidytable::distinct(cutoff, tidytable::all_of(SIGNAL_TYPES), ms1) |>
  tidyr::pivot_longer(cols = tidytable::all_of(SIGNAL_TYPES)) |>
  tidytable::mutate(value = value / ms1)

## Switching values to single identity only
df_combined_single <- df_combined |>
  tidytable::mutate(
    fragment = co,
    adduct = ao + aic,
    isotope = io + aii + iic + ei
  ) |>
  tidytable::mutate(fragmented_percent = fragment / ms1)

## Pivoting and filtering spectra where at least 10% was fragmented
df_pivoted <- df_combined_single |>
  tidytable::filter(fragmented / ms1 >= 0.1) |>
  tidytable::distinct(cutoff, tidytable::all_of(SIGNAL_TYPES), ms1) |>
  tidyr::pivot_longer(cols = tidytable::all_of(SIGNAL_TYPES)) |>
  tidytable::mutate(value = value / ms1)

df_combined_classes <- df_standards_full_2 |>
  tidytable::mutate_rowwise(
    cutoff = stringi::stri_replace_all_regex(
      str = cutoff,
      pattern = gsub(
        pattern = "data/",
        replacement = "",
        x = c(
          path_dirs_standards |> unlist() |> unname(),
          path_dirs_unknowns |> unlist() |> unname()
        )
      ),
      replacement = c(names(path_dirs_standards), names(path_dirs_unknowns)),
      vectorise_all = FALSE
    )
  ) |>
  # tidytable::filter(fragmented_percent>= 0.25) |>
  tidytable::mutate(cutoff = gsub("(di_ot_neg)(.*)", "\\1", cutoff)) |>
  tidytable::mutate(cutoff = gsub("(di_ot_pos)(.*)", "\\1", cutoff))

df_pivoted_classes_adducts <- df_combined_classes |>
  # tidytable::filter(!grepl(pattern = "-", x = adduct_type, fixed = TRUE)) |>
  tidytable::filter(adduct_type %in% c("[M+H]+", "[M+Na]+", "[M-H]-")) |>
  tidytable::filter(cutoff == "di_ot_pos" |
    cutoff == "di_ot_neg") |>
  tidytable::distinct(smiles, cutoff, count_fragments_row, ms1, adduct_type) |>
  tidyr::pivot_longer(cols = count_fragments_row) |>
  tidytable::group_by(adduct_type, value) |>
  tidytable::add_count() |>
  tidytable::ungroup() |>
  tidytable::group_by(adduct_type) |>
  tidytable::add_count(name = "m") |>
  tidytable::mutate(rank = tidytable::dense_rank(desc(m))) |>
  tidytable::ungroup() |>
  tidytable::filter(m >= 10) |>
  tidytable::filter(rank <= 20) |>
  tidytable::filter(n >= 2) |>
  tidytable::distinct()

## Minimal
df_minimal <- df_combined_single |>
  tidytable::filter(cutoff %in% EXAMPLES) |>
  tidytable::mutate(cutoff = cutoff |>
    stringi::stri_replace_last_regex(pattern = "_[0-9].*", replacement = ""))

if (!"example=TRUE" %in% args) {
  library(ggrepel)
  pal <- c("#F39B7FFF", "#8491B4FF", "#91D1C2FF")
  rainplot_adducts <- plot_distributions(
    df = df_pivoted_classes_adducts |>
      tidytable::mutate(value = ifelse(
        test = value >= 10,
        yes = 10,
        no = value
      )) |>
      tidytable::mutate(cutoff = TRANSLATIONS[cutoff]) |>
      tidytable::mutate(
        adduct_type = gsub(
          pattern = "H4",
          replacement = "H<sub>4</sub>",
          x = adduct_type,
          fixed = TRUE
        )
      ) |>
      tidytable::mutate(
        adduct_type = gsub(
          pattern = "]+",
          replacement = "]<sup>+</sup>",
          x = adduct_type,
          fixed = TRUE
        )
      ) |>
      tidytable::mutate(
        adduct_type = gsub(
          pattern = "]-",
          replacement = "]<sup>-</sup>",
          x = adduct_type,
          fixed = TRUE
        )
      ),
    group = "adduct_type",
    facet = "adduct_type",
    value = "value",
    axis_label = "MS² fragments in MS¹",
    reorder = c(
      "[M+H]<sup>+</sup>",
      "[M-H]<sup>-</sup>",
      "[M+Na]<sup>+</sup>"
    ),
    plot_histograms = TRUE
  ) +
    ggplot2::xlim(c(0, 11)) +
    ggplot2::scale_x_continuous(
      limits = c(-1, 11),
      breaks = c(seq(0, 10, by = 1)),
      labels = c(seq(0, 9, by = 1), "10+")
    ) +
    ggplot2::guides(color = ggplot2::guide_legend(nrow = 3, byrow = TRUE))

  relative_intensities_1 <- plot_distributions_relative_intensities(df_intensities_5, pal = "#3C5488FF")
  relative_intensities_2 <- plot_distributions_relative_intensities(df_intensities_3, pal = c("#DC0000FF", "#F39B7FFF"))
  
}

## Export
if (!"example=TRUE" %in% args) {
  rainplot_adducts |>
    export_figure(
      "man/figures/subfig_a",
      extension = "svg"
    )
  relative_intensities_1 |>
    export_figure(
      "man/figures/subfig_b",
      extension = "svg"
    )
  relative_intensities_2 |>
    export_figure(
      "man/figures/subfig_c",
      extension = "svg"
    )
}
end <- Sys.time()

message("Script finished in ", crayon::green(format(end - start)))
