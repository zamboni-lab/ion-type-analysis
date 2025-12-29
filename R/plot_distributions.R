#' Plot distributions
#'
#' @param df
#' @param group
#' @param value
#' @param axis_label
#' @param title
#' @param subtitle
#' @param caption
#' @param reorder
#' @param plot_histograms
#' @param normalize_xlim
#'
#' @return
#'
#' @examples
plot_distributions <- function(df,
                               facet,
                               group,
                               value,
                               axis_label = "",
                               title = "",
                               subtitle = "",
                               caption = "",
                               reorder = NULL,
                               plot_histograms = FALSE,
                               normalize_xlim = TRUE) {
  df_prep <- df |>
    tidytable::mutate(!!as.name(facet) := gsub("_", " ", !!as.name(facet))) |>
    tidytable::filter(!is.na(!!as.name(group))) |>
    tidytable::group_by(c(!!as.name(group), !!as.name(facet))) |>
    tidytable::mutate(
      median_value = median(!!as.name(value)),
      max_value = max(!!as.name(value))
    ) |>
    tidytable::mutate(max_density = tidytable::map_dbl(list(density(
      !!as.name(value),
      na.rm = TRUE
    )), ~ max(.x$y))) |>
    tidytable::group_by(!!as.name(facet)) |>
    tidytable::mutate(
      mmax_density = max(max_density),
      count = max(tidytable::cur_group_rows()) / length(unique(name))
    ) |>
    tidytable::ungroup() |>
    tidytable::mutate(
      facet_original = !!as.name(facet),
      !!as.name(facet) := paste0(!!as.name(facet), ", n=", count)
    ) |>
    tidytable::mutate(!!as.name(facet) := forcats::fct(!!as.name(facet)))

  if (plot_histograms) {
    df_prep <- df_prep |>
      tidytable::group_by(!!as.name(facet)) |>
      tidytable::mutate(max_value = max(n)) |>
      tidytable::ungroup()
  }

  if (!is.null(reorder)) {
    reorder2 <- reorder |>
      tidytable::tidytable() |>
      tidytable::left_join(df_prep, by = c("reorder" = "facet_original")) |>
      tidytable::distinct(!!as.name(facet)) |>
      tidytable::pull() |>
      as.character()
    df_prep <- df_prep |>
      tidytable::mutate(!!as.name(facet) := forcats::fct_relevel(!!as.name(facet), reorder2))
  }

  plot <- df_prep |>
    ggplot2::ggplot(ggplot2::aes(
      x = !!as.name(value),
      color = !!as.name(group)
    )) +
    ggplot2::facet_grid(rows = ggplot2::vars(!!as.name(facet)), scales = "free_y")
  if (!plot_histograms) {
    plot <- plot +
      ggplot2::geom_density(
        ggplot2::aes(
          group = !!as.name(group),
          fill = !!as.name(group)
        ),
        stat = "density",
        alpha = 0.1
      )
  }
  if (plot_histograms) {
    plot <- plot +
      ggplot2::geom_histogram(
        ggplot2::aes(
          color = !!as.name(group),
          fill = !!as.name(group)
        ),
        alpha = 0.1,
        binwidth = 1
      )
  }
  if (!plot_histograms) {
    plot <- plot +
      ggplot2::geom_text(
        ggplot2::aes(
          x = ifelse(
            test = normalize_xlim,
            yes = 0.99,
            no = max(df_prep$value)
          ),
          y = mmax_density + 3,
          label = !!as.name(facet)
        ),
        hjust = 1,
        fontface = "bold",
        color = "#767676",
        check_overlap = TRUE
      )
  }
  plot <- plot +
    ggrepel::geom_label_repel(
      data = df_prep |>
        tidytable::distinct(
          median_value,
          max_density, !!as.name(group), !!as.name(facet)
        ),
      ggplot2::aes(
        x = median_value,
        y = 1.2 * max_density,
        label = format(round(median_value, 2), nsmall = 2),
        color = !!as.name(group)
      ),
      show.legend = FALSE
    )
  if (normalize_xlim) {
    plot <- plot +
      ggplot2::xlim(0, 1)
  }
  plot <- plot +
    ggplot2::scale_color_manual(values = pal, name = "") +
    ggplot2::scale_fill_manual(values = pal, name = "") +
    ggplot2::labs(
      x = axis_label,
      y = ifelse(plot_histograms, "Count", "Density"),
      title = title,
      subtitle = subtitle,
      caption = caption
    ) +
    ggplot2::theme_minimal(base_size = 15) +
    ggplot2::theme(
      legend.position = "top",
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text = ggtext::element_markdown(color = "#767676"),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title = ggtext::element_markdown(color = "#767676"),
      legend.text = ggtext::element_markdown(color = "#767676"),
      plot.title = ggplot2::element_blank(),
      plot.subtitle = ggplot2::element_blank(),
      plot.caption = ggplot2::element_blank(),
      strip.text = ggplot2::element_blank(),
      text = ggplot2::element_text(face = "bold", color = "#767676")
    )
  if (plot_histograms) {
    plot <- plot +
      ggplot2::theme(
        axis.text.y = ggplot2::element_text(color = "#767676")
      )
  }
  plot
}
