#' Plot distributions
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
#' @export
#'
#' @examples
plot_distributions <- function(df,
                               facet,
                               group,
                               value,
                               axis_label = "",
                               title = "",
                               subtitle = "",
                               caption = "") {
  df <- df |>
    tidytable::mutate(!!as.name(facet) := gsub("_", " ", !!as.name(facet))) |>
    tidytable::mutate(!!as.name(facet) := forcats::fct_rev(!!as.name(facet))) |>
    tidytable::filter(!is.na(!!as.name(group))) |>
    tidytable::group_by(c(!!as.name(group), !!as.name(facet))) |>
    tidytable::mutate(median_value = median(!!as.name(value))) |>
    tidytable::mutate(density = list(density(!!as.name(value), na.rm = TRUE))) |>
    tidytable::mutate(max_density = tidytable::map_dbl(density, ~ max(.x$y))) |>
    tidytable::group_by(!!as.name(facet)) |>
    tidytable::mutate(mmax_density = max(max_density)) |>
    tidytable::ungroup()

  df |>
    ggplot2::ggplot(ggplot2::aes(
      x = !!as.name(value),
      color = !!as.name(group),
      # fill = !!as.name(group)
    )) +
    ggplot2::facet_grid(rows = ggplot2::vars(!!as.name(facet)), scales = "free_y") +
    ggplot2::geom_line(ggplot2::aes(group = !!as.name(group)),
      stat = "density",
      linewidth = 1
    ) +
    ggplot2::geom_text(
      ggplot2::aes(
        x = 0.99,
        y = mmax_density + 3,
        label = !!as.name(facet)
      ),
      hjust = 1,
      fontface = "bold",
      color = "grey30"
    ) +
    ggrepel::geom_label_repel(
      data = df |>
        tidytable::distinct(
          median_value,
          max_density,
          !!as.name(group),
          !!as.name(facet)
        ),
      ggplot2::aes(
        x = median_value,
        y = 1.2 * max_density,
        label = format(round(median_value, 2), nsmall = 2),
        color = !!as.name(group)
      ),
      show.legend = FALSE
    ) +
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
    ggplot2::xlim(0, 1) +
    ggplot2::theme_minimal(base_size = 15) +
    ggplot2::theme(
      legend.position = "bottom",
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(color = "grey30"),
      axis.text.y = ggplot2::element_blank(),
      # strip.text.y.right = ggplot2::element_text(angle = 0),
      axis.title = ggplot2::element_text(color = "grey30"),
      legend.text = ggplot2::element_text(color = "grey30"),
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
      # plot.margin = ggplot2::margin(15, 15, 10, 15),
      strip.text = ggplot2::element_blank(),
      text = ggplot2::element_text(face = "bold", color = "grey30")
    )
}
