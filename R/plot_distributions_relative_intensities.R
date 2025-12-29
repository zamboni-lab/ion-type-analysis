#' Plot distributions relative intensities
#'
#' @include calculate_jsd.R
#'
#' @param df Df
#' @param type_1 Type 1
#' @param type_2 Type 2
#' @param pal Pal
#'
#' @return
#'
#' @examples
plot_distributions_relative_intensities <- function(df,
                                                    type_1 = "more than 2 -OH",
                                                    type_2 =
                                                      "2 -OH or less",
                                                    pal = c("#DC0000FF", "#E64B35FF", "#F39B7FFF")) {
  medians <- df |>
    tidytable::group_by(type, type_2) |>
    tidytable::summarize(median = median(ratio)) |>
    tidytable::ungroup()

  jsd <- df |>
    tidytable::group_by(type) |>
    tidytable::mutate(jsd = calculate_jsd(highest_fragment_intensity[type_2 == type_1], highest_fragment_intensity[type_2 == type_2])) |>
    tidytable::ungroup() |>
    tidytable::distinct(type, jsd) |>
    tidytable::full_join(df |>
      tidytable::distinct(type, type_2))

  plot <- df |>
    ggplot2::ggplot(mapping = ggplot2::aes(
      x = ratio,
      y = type,
      color = type,
      fill = type,
      linetype = type_2
    )) +
    ggplot2::geom_vline(xintercept = 1, linetype = "dashed") +
    ggplot2::scale_color_manual(values = pal) +
    ggplot2::scale_fill_manual(values = pal) +
    ggplot2::scale_x_log10(
      labels = function(x) {
        sprintf("%g", x)
      },
      breaks = c(0.001, 0.01, 0.1, 1, 10, 100, 1000)
    ) +
    ggridges::geom_density_ridges(alpha = 0.5, scale = 1) +
    ggrepel::geom_label_repel(
      fill = "white",
      data = medians,
      mapping = ggplot2::aes(
        y = type,
        x = median,
        label = format(round(median, 2), nsmall = 2)
      ),
      nudge_y = 0,
      show.legend = FALSE
    ) +
    ggplot2::scale_y_discrete(limits = sort(unique(df$type), decreasing = TRUE)) +
    ggplot2::labs(
      x = "Relative intensity to precursor",
      y = "Density",
      color = "",
      fill = "",
      linetype = ""
    ) +
    ggplot2::scale_linetype_manual(values = c("dotted", "longdash", "dotted", "longdash")) +
    ggplot2::geom_text(
      data = jsd,
      ggplot2::aes(
        x = 100,
        y = type,
        color = type,
        label = paste("JSd:", format(round(jsd, 2), nsmall = 2))
      ),
      nudge_y = 0.2,
      show.legend = FALSE
    ) +
    ggplot2::theme_minimal(base_size = 15) +
    ggplot2::guides(
      color = ggplot2::guide_legend(
        nrow = 3,
        byrow = TRUE,
        order = 1
      ),
      fill = ggplot2::guide_legend(
        nrow = 3,
        byrow = TRUE,
        order = 1
      ),
      linetype = ggplot2::guide_legend(
        nrow = 2,
        byrow = TRUE,
        order = 2
      )
    ) +
    ggplot2::theme(
      legend.position = "top",
      legend.box = "horizontal",
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
  return(plot)
}
