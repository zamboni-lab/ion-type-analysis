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
  df_standards <- path_dirs_standards |>
    import_dirs(fun = import_standards, columns = COLNAMES) |>
    tidytable::bind_rows() |>
    tidytable::distinct()
}

### Unknowns
df_unknowns <- path_dirs_unknowns |>
  import_dirs(fun = import_unknowns, columns = COLNAMES) |>
  tidytable::bind_rows() |>
  tidytable::distinct()

## Combining
if (!"example=TRUE" %in% args) {
  df_combined <- df_standards |>
    tidytable::bind_rows(df_unknowns)
} else {
  df_combined <- df_unknowns
}

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
  tidytable::mutate(cutoff = gsub("(di_ot_neg)(.*)", "\\1", cutoff)) |>
  tidytable::mutate(cutoff = gsub("(di_ot_pos)(.*)", "\\1", cutoff))

## Pivoting
df_pivoted_before <- df_combined |>
  tidytable::distinct(cutoff, tidytable::all_of(SIGNAL_TYPES), ms1) |>
  tidyr::pivot_longer(cols = tidytable::all_of(SIGNAL_TYPES)) |>
  tidytable::mutate(value = value / ms1)

pal <- choose_pal(subclasses = length(SIGNAL_TYPES))

## Minimal
if (!"example=TRUE" %in% args) {
  df_minimal <- df_combined |>
    tidytable::filter(cutoff %in% EXAMPLES) |>
    tidytable::mutate(cutoff = cutoff |>
      stringi::stri_replace_last_regex(pattern = "_[0-9].*", replacement = ""))

  ## Illustrating shared annotations and strategy
  df_venn <- df_unknowns |>
    tidytable::select(tidytable::all_of(SIGNAL_TYPES_FULL)) |>
    tidytable::mutate(sum = rowSums(tidytable::across(tidytable::everything()))) |>
    tidytable::filter(sum == min(sum)) |>
    head(1) |>
    venn_prepare_df()

  venn_simple <- df_venn |>
    venn_plot_simple()
  # venn_simple

  venn_highlighted <- venn_simple |>
    venn_plot_highlighted(df_venn = df_venn)
  # venn_highlighted
  ## Taking the first plots
  rainplot_astral_before <- plot_distributions(
    df = df_pivoted_before |>
      tidytable::filter(cutoff == "lc_at_pos"),
    group = "name",
    facet = "cutoff",
    value = "value",
    axis_label = "Proportion of MS¹ centroids"
  )
}
rainplot_tof_2_before <- plot_distributions(
  df = df_pivoted_before |>
    tidytable::filter(cutoff == "di_tof_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2_before
rainplot_orbitrap_pos_before <- plot_distributions(
  df = df_pivoted_before |>
    tidytable::filter(cutoff == "di_ot_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_pos_before
rainplot_orbitrap_neg_before <- plot_distributions(
  df = df_pivoted_before |>
    tidytable::filter(cutoff == "di_ot_neg"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_neg_before

## Switching values to single identity only
df_combined_single <- df_combined |>
  tidytable::mutate(
    fragment = co,
    adduct = ao + aic,
    isotope = io + aii + iic + ei
  ) |>
  tidytable::mutate(fragmented_percent = fragment / ms1)

## Pivoting
df_pivoted <- df_combined_single |>
  tidytable::distinct(cutoff, tidytable::all_of(SIGNAL_TYPES), ms1) |>
  tidyr::pivot_longer(cols = tidytable::all_of(SIGNAL_TYPES)) |>
  tidytable::mutate(value = value / ms1)

## Minimal
df_minimal <- df_combined_single |>
  tidytable::filter(cutoff %in% EXAMPLES) |>
  tidytable::mutate(cutoff = cutoff |>
    stringi::stri_replace_last_regex(pattern = "_[0-9].*", replacement = ""))

## Plotting
rainplot_tof_1 <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_0_20ev_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_1
rainplot_tof_2 <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2
rainplot_tof_2_40ev <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_5_40ev_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2_40ev
rainplot_tof_2_60ev <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_5_60ev_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2_60ev
rainplot_tof_3 <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_10_20ev_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_3
rainplot_orbitrap_pos <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_ot_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_pos
rainplot_orbitrap_neg <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_ot_neg"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_neg
rainplot_astral <- plot_distributions(
  df = df_pivoted |>
    tidytable::filter(cutoff == "lc_at_pos"),
  group = "name",
  facet = "cutoff",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_astral

if (!"example=TRUE" %in% args) {
  rainplot_types_before <- df_pivoted_before |>
    tidytable::filter(cutoff %in% EXAMPLES) |>
    plot_distributions(
      group = "name",
      facet = "cutoff",
      value = "value",
      axis_label = "Proportion of MS¹ centroids"
    )
  rainplot_types <- df_pivoted |>
    tidytable::filter(cutoff %in% EXAMPLES) |>
    plot_distributions(
      group = "name",
      facet = "cutoff",
      value = "value",
      axis_label = "Proportion of MS¹ centroids"
    )
  rainplot_threshold <- df_pivoted |>
    tidytable::filter(cutoff %in% THRESHOLDS) |>
    plot_distributions(
      group = "name",
      facet = "cutoff",
      value = "value",
      axis_label = "Proportion of MS¹ centroids"
    )
  rainplot_energy <- df_pivoted |>
    tidytable::filter(cutoff %in% ENERGIES) |>
    plot_distributions(
      group = "name",
      facet = "cutoff",
      value = "value",
      axis_label = "Proportion of MS¹ centroids"
    )
}

## Export
export_figure <- function(figure,
                          filename,
                          extension = EXTENSION,
                          height = 9,
                          width = 16) {
  path <- paste(filename, extension, sep = ".")
  if (extension == "png") {
    ggplot2::ggsave(figure,
      filename = path,
      height = height,
      width = width
    )
  } else {
    ggpubr::ggexport(figure,
      filename = path,
      height = height,
      width = width
    )
  }
}
if (!"example=TRUE" %in% args) {
  rainplot_types_before |>
    export_figure(filename = "man/figures/rainplot_types_before")

  rainplot_types |>
    export_figure(filename = "man/figures/rainplot_types")

  rainplot_threshold |>
    export_figure(filename = "man/figures/rainplot_thresholds")

  rainplot_energy |>
    export_figure(filename = "man/figures/rainplot_energy")

  venn_simple |>
    export_figure(
      filename = "man/figures/venn_simple",
      height = 7,
      width = 7
    )

  venn_highlighted |>
    export_figure(
      filename = "man/figures/venn_highlighted",
      height = 7,
      width = 7
    )
} else {
  rainplot_tof_2_before |>
    export_figure(filename = "man/figures/rainplot_types_before_example")
  rainplot_tof_2 |>
    export_figure(filename = "man/figures/rainplot_types_example")
}
end <- Sys.time()

message("Script finished in ", crayon::green(format(end - start)))
