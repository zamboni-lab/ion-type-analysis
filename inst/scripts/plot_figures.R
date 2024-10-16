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
  path_dirs_unknowns <- list(di_tof_10_20ev_pos = "data/example/di_tof_10_20ev_pos")
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
  rainplot_astral_before <- rainplots_by_group(
    df = df_pivoted_before |>
      tidytable::filter(cutoff == "lc_at_5_pos"),
    group = "name",
    value = "value",
    axis_label = "Proportion of MS¹ centroids"
  )
}
rainplot_tof_2_before <- rainplots_by_group(
  df = df_pivoted_before |>
    tidytable::filter(cutoff == "di_tof_10_20ev_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2_before
rainplot_orbitrap_pos_before <- rainplots_by_group(
  df = df_pivoted_before |>
    tidytable::filter(cutoff == "di_ot_2.5_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_pos_before

## Switching values to single identity only
df_combined_single <- df_combined |>
  tidytable::mutate(
    fragments = co,
    adducts = ao + aic,
    isotopes = io + aii + iic + ei
  ) |>
  tidytable::mutate(fragmented_percent = fragments / ms1)

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
rainplot_tof_1 <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_0_20ev_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_1
rainplot_tof_2 <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_10_20ev_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2
rainplot_tof_2_40ev <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_10_40ev_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2_40ev
rainplot_tof_2_60ev <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_10_60ev_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_2_60ev
rainplot_tof_3 <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_tof_100_20ev_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_tof_3
rainplot_orbitrap_pos <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_ot_2.5_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_pos
rainplot_orbitrap_neg <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "di_ot_2.5_neg"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_orbitrap_neg
rainplot_astral <- rainplots_by_group(
  df = df_pivoted |>
    tidytable::filter(cutoff == "lc_at_5_pos"),
  group = "name",
  value = "value",
  axis_label = "Proportion of MS¹ centroids"
)
# rainplot_astral

if (!"example=TRUE" %in% args) {
  rainplot_types_before <- ggpubr::ggarrange(
    rainplot_tof_2_before,
    rainplot_orbitrap_pos_before,
    rainplot_astral_before,
    labels = c(
      "DI-ToF (standards)",
      "DI-Orbitrap (standards)",
      "LC-Astral (NIST human fecal extract)"
    ),
    common.legend = TRUE,
    legend = "bottom",
    ncol = 3,
    font.label = list(color = "grey30")
  )
  rainplot_types <- ggpubr::ggarrange(
    rainplot_tof_2,
    rainplot_orbitrap_pos,
    rainplot_astral,
    labels = c(
      "DI-ToF (standards)",
      "DI-Orbitrap (standards)",
      "LC-Astral (NIST human fecal extract)"
    ),
    common.legend = TRUE,
    legend = "bottom",
    ncol = 3,
    font.label = list(color = "grey30")
  )
  rainplot_threshold <- ggpubr::ggarrange(
    rainplot_tof_1,
    rainplot_tof_2,
    rainplot_tof_3,
    labels = c(
      "DI-ToF, no threshold",
      "DI-ToF, lowest signal x10",
      "DI-ToF, lowest signal x100"
    ),
    common.legend = TRUE,
    legend = "bottom",
    ncol = 3,
    font.label = list(color = "grey30")
  )
  rainplot_polarity <- ggpubr::ggarrange(
    labels = c("DI-Orbitrap (positive)", "DI-Orbitrap (negative)"),
    rainplot_orbitrap_pos,
    rainplot_orbitrap_neg,
    common.legend = TRUE,
    legend = "bottom"
  )
  rainplot_energy <- ggpubr::ggarrange(
    labels = c("DI-ToF, 20eV", "DI-ToF, 40eV", "DI-ToF, 60eV"),
    rainplot_tof_2,
    rainplot_tof_2_40ev,
    rainplot_tof_2_60ev,
    common.legend = TRUE,
    legend = "bottom",
    ncol = 3,
    font.label = list(color = "grey30")
  )
}

pal <- choose_pal(length(unique(df_minimal$cutoff)))

rainplot_fragmented_centroids <- rainplots_by_group(
  df = df_minimal,
  group = "cutoff",
  value = "fragmented_percent",
  axis_label = "Proportion of MS¹ centroids fragmented"
)
# rainplot_fragmented_centroids

rainplot_fragmented_intensity <- rainplots_by_group(
  df = df_minimal,
  group = "cutoff",
  value = "fragmented_intensity_percent",
  axis_label = "Proportion of MS¹ intensity fragmented"
)
# rainplot_fragmented_intensity

rainplot_fragmented <- ggpubr::ggarrange(rainplot_fragmented_centroids,
  rainplot_fragmented_intensity,
  common.legend = TRUE
)

relation <- df_minimal |>
  ggplot2::ggplot(
    mapping = ggplot2::aes(
      x = fragmented_percent,
      y = fragments,
      group = cutoff,
      color = cutoff,
      fill = cutoff
    )
  ) +
  ggplot2::scale_color_manual(values = pal, name = "") +
  ggplot2::scale_fill_manual(values = pal, name = "") +
  ggplot2::geom_point(alpha = 0.2) +
  ggplot2::geom_smooth(method = "lm") +
  ggplot2::xlab("Ratio of fragmented centroids") +
  ggplot2::ylab("Count of common centroids") +
  ggplot2::scale_y_log10() +
  ggplot2::scale_x_log10() +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    axis.text = ggplot2::element_text(colour = "grey30"),
    axis.title = ggplot2::element_text(colour = "grey30"),
    strip.text = ggplot2::element_text(colour = "grey30"),
    legend.text = ggplot2::element_text(colour = "grey30"),
    text = ggplot2::element_text(face = "bold", color = "grey30")
  )

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

  rainplot_polarity |>
    export_figure(filename = "man/figures/rainplot_polarity")

  rainplot_energy |>
    export_figure(filename = "man/figures/rainplot_energy")

  rainplot_fragmented |>
    export_figure(filename = "man/figures/rainplot_fragmented")

  relation |>
    export_figure(filename = "man/figures/relation_fragmented")

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
  rainplot_fragmented |>
    export_figure(filename = "man/figures/rainplot_fragmented_example")
  relation |>
    export_figure(filename = "man/figures/relation_fragmented_example")
}
end <- Sys.time()

message("Script finished in ", crayon::green(format(end - start)))
