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
  df |>
    tidytable::filter(!is.na(!!as.name(group))) |>
    ggplot2::ggplot(ggplot2::aes(
      x = !!as.name(value),
      color = !!as.name(group)
    )) +
    ggplot2::facet_grid(rows = ggplot2::vars(!!as.name(facet))) +
    ggdist::stat_halfeye(
      ggplot2::aes(
        color = !!as.name(group),
        fill = ggplot2::after_scale(x = color)
      ),
      normalize = "panels",
      alpha = 0.5
    ) +
    ggplot2::stat_summary(
      geom = "text",
      fun = "median",
      ggplot2::aes(
        y = NA,
        label = round(ggplot2::after_stat(x), 2),
      ),
      fontface = "bold",
      show.legend = FALSE
    ) +
    ggplot2::scale_color_manual(values = pal, name = "") +
    ggplot2::scale_fill_manual(values = pal, name = "") +
    ggplot2::labs(
      x = NULL,
      y = axis_label,
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
      axis.text = ggplot2::element_text(colour = "grey30"),
      axis.text.y = ggplot2::element_blank(),
      strip.text.y.right = ggplot2::element_text(angle = 0),
      axis.title = ggplot2::element_text(colour = "grey30"),
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
