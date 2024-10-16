## THIS NEEDS POLISHING

#' Title TODO
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
rainplots_by_group <- function(df,
                               group,
                               value,
                               axis_label = "",
                               title = "",
                               subtitle = "",
                               caption = "") {
  df |>
    dplyr::filter(!is.na(!!as.name(group))) |>
    ggplot2::ggplot(ggplot2::aes(
      x = !!as.name(group),
      y = !!as.name(value),
      color = !!as.name(group)
    )) +
    ggdist::stat_halfeye(
      ggplot2::aes(
        color = !!as.name(group),
        fill = ggplot2::after_scale(x = colorspace::lighten(col = color, .5))
      ),
      adjust = .5,
      width = .6,
      .width = 0,
      justification = -.4,
      point_color = NA
    ) +
    ggplot2::geom_point(
      ggplot2::aes(color = ggplot2::after_scale(
        colorspace::darken(color, .1, space = "HLS")
      )),
      fill = "white",
      shape = 21,
      stroke = .4,
      size = 2,
      position = ggplot2::position_jitter(seed = 1, width = .12)
    ) +
    ggplot2::geom_point(
      ggplot2::aes(fill = !!as.name(group)),
      color = "transparent",
      shape = 21,
      stroke = .4,
      size = 2,
      alpha = .1,
      position = ggplot2::position_jitter(seed = 1, width = .12)
    ) +
    ggplot2::stat_summary(
      geom = "text",
      fun = "median",
      ggplot2::aes(
        label = round(ggplot2::after_stat(y), 2),
        color = !!as.name(group),
      ),
      fontface = "bold",
      size = 4.5,
      vjust = -3.5,
      show.legend = FALSE
    ) +
    ggplot2::stat_summary(
      geom = "text",
      fun.data = add_sample,
      ggplot2::aes(
        label = paste("n =", ggplot2::after_stat(label)),
        color = !!as.name(group),
      ),
      size = 4,
      hjust = 0,
      show.legend = FALSE
    ) +
    ggplot2::geom_boxplot(
      ggplot2::aes(
        color = !!as.name(group),
        fill = ggplot2::after_scale(colorspace::desaturate(col = colorspace::lighten(col = color, .8), .4))
      ),
      alpha = .5,
      outlier.alpha = 0.1,
      width = .2,
      outlier.shape = NA
    ) +
    ggplot2::ylim(0, 1) +
    ggplot2::coord_flip(xlim = c(1.2, NA), clip = "off") +
    ggplot2::scale_color_manual(values = pal, name = "") +
    ggplot2::scale_fill_manual(values = pal, name = "") +
    ggplot2::labs(
      x = NULL,
      y = axis_label,
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
