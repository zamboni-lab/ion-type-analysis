#' Venn plot simple
#'
#' @param df
#'
#' @return
#'
#' @examples
venn_plot_simple <- function(df) {
  venn <- (
    ggplot2::ggplot(ComplexUpset::arrange_venn(df))
    +
      ggplot2::coord_fixed()
      +
      ggplot2::theme_void()
      +
      ComplexUpset::scale_color_venn_mix(df, colors = c("#990000", "#006699", "#339966"))
  )
  (
    venn
    + ComplexUpset::geom_venn_region(data = df, alpha = 0.05)
      + ggplot2::geom_point(ggplot2::aes(
        x = x, y = y, color = region
      ))
      + ComplexUpset::geom_venn_circle(df, color = "#484848")
      + ComplexUpset::geom_venn_label_set(df, ggplot2::aes(label = region), outwards_adjust = 2)
      + ComplexUpset::geom_venn_label_region(df, ggplot2::aes(label = size))
      + ComplexUpset::scale_fill_venn_mix(df, guide = "none")
      + ggplot2::theme(
        legend.position = "none",
        text = ggplot2::element_text(face = "bold", color = "#767676")
      )
  )
}
