#' Plot upset
#'
#' @param df_venn
#'
#' @return
#'
#' @examples
plot_upset <- function(df_venn) {
  df_upset <- df_venn |> tidytable::mutate(
    "non-redundant" = tidytable::if_else(
      condition = adducts == FALSE & fragments == FALSE & isotopes == FALSE,
      true = TRUE,
      false = FALSE
    )
  )

  ComplexUpset::upset(
    data = df_upset,
    intersect = c("adducts", "fragments", "isotopes", "non-redundant"),
    mode = "exclusive_intersection",
    set_sizes = FALSE,
    name = "Ion type",
    encode_sets = FALSE,
    stripes = ComplexUpset::upset_stripes(colors = c(NA, NA)),
    themes = ComplexUpset::upset_default_themes(text = ggplot2::element_text(
      face = "bold", color = "grey30"
    )),
    base_annotations = list(
      "Size" = (
        ComplexUpset::intersection_size(
          mode = "exclusive_intersection",
          mapping = ggplot2::aes(fill = exclusive_intersection),
          size = 0,
          text_colors = c(on_background = "grey40", on_bar = "white"),
          text = list(check_overlap = TRUE)
        ) + ggplot2::scale_fill_manual(
          name = "",
          values = c(
            "adducts" = pal[1],
            "adducts-fragments" = pal[1],
            "adducts-fragments-isotopes" = pal[3],
            "adducts-isotopes" = pal[3],
            "fragments" = pal[2],
            "fragments-isotopes" = pal[3],
            "isotopes" = pal[3]
          ),
          na.value = pal[4],
          na.translate = TRUE,
          labels = c("adducts", "isotopes", "fragments", "non-redundant"),
          breaks = c("adducts", "isotopes", "fragments", NA),
          limits = c(
            "adducts",
            "adducts-fragments",
            "adducts-fragments-isotopes",
            "adducts-isotopes",
            "fragments",
            "fragments-isotopes",
            "isotopes",
            NA
          )
          # guide = "none"
        ) +
          ggplot2::labs(title = "") +
          ggplot2::theme_minimal(base_size = 15) +
          ggplot2::theme(
            legend.position = "top",
            axis.text = ggplot2::element_text(colour = "grey30"),
            axis.text.x = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_blank(),
            axis.title = ggplot2::element_text(colour = "grey30"),
            axis.title.x = ggplot2::element_blank(),
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
            plot.background = ggplot2::element_rect(
              fill = "transparent", color =
                NA
            ),
            plot.margin = ggplot2::margin(15, 15, 10, 15),
            strip.text = ggplot2::element_text(colour = "grey30"),
            text = ggplot2::element_text(face = "bold", color = "grey30")
          )
      )
    )
  ) &
    ggplot2::theme(plot.background = ggplot2::element_rect(
      fill = "transparent", color =
        NA
    ))
}
