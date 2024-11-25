#' Rainplots by group
#'
#' @param df
#' @param group
#' @param value
#' @param axis_label
#' @param title
#' @param subtitle
#' @param caption
#'
#' @return
#'
#' @examples
rainplots_by_group <- function(df,
                               group,
                               value,
                               axis_label = "",
                               title = "",
                               subtitle = "",
                               caption = "") {
  df |>
    tidytable::filter(!is.na(!!as.name(group))) |>
    tidytable::group_by(c(!!as.name(group), "cutoff")) |>
    tidytable::mutate(median_value = median(!!as.name(value))) |>
    tidytable::mutate(density = list(density(!!as.name(value), na.rm = TRUE))) |>
    tidytable::mutate(max_density = tidytable::map_dbl(density, ~ max(.x$y))) |>
    tidytable::ungroup() |>
    ggplot2::ggplot(ggplot2::aes(
      x = !!as.name(value),
      color = !!as.name(group),
      fill = !!as.name(group)
    )) +
    ggplot2::geom_density(ggplot2::aes(group = !!as.name(group)),
      alpha = 0.1,
      linewidth = 1
    ) +
    ggplot2::geom_text(ggplot2::aes(
      x = median_value,
      y = max_density + 1,
      label = round(median_value, 2),
      color = !!as.name(group)
    )) +
    ggplot2::xlim(0, 1) +
    ggplot2::scale_color_manual(values = pal, name = "") +
    ggplot2::scale_fill_manual(values = pal, name = "") +
    ggplot2::labs(
      x = axis_label,
      y = "Density",
      title = title,
      subtitle = subtitle,
      caption = caption
    ) +
    ggplot2::theme_minimal(base_size = 15) +
    ggplot2::theme(
      legend.position = "bottom",
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(colour = "grey30"),
      axis.text.y = ggplot2::element_blank(),
      axis.title = ggplot2::element_text(colour = "grey30"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 10), size = 16),
      legend.text = ggplot2::element_text(colour = "grey30"),
      plot.title = ggtext::element_markdown(face = "bold", size = 21),
      plot.subtitle = ggplot2::element_text(
        color = "grey40",
        hjust = 0,
        margin = ggplot2::margin(0, 0, 20, 0)
      ),
      plot.title.position = "plot",
      plot.caption = ggtext::element_markdown(
        color = "grey40",
        lineheight = 1.2,
        margin = ggplot2::margin(20, 0, 0, 0)
      ),
      plot.margin = ggplot2::margin(15, 15, 10, 15),
      strip.text = ggplot2::element_text(colour = "grey30"),
      text = ggplot2::element_text(face = "bold", color = "grey30")
    )
}
