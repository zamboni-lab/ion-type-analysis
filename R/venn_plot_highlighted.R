#' Venn plot highlighted
#'
#' @param df_venn
#' @param venn_simple
#'
#' @return
#' @export
#'
#' @examples
venn_plot_highlighted <- function(df_venn, venn_simple) {
  venn_highlighted <- (
    ggplot2::ggplot(ComplexUpset::arrange_venn(df_venn)) +
      ggplot2::coord_fixed()
      +
      ggplot2::theme_void()
      +
      ComplexUpset::geom_venn_region(data = df_venn, alpha = 0.3)
      +
      ggplot2::geom_point(ggplot2::aes(x = x, y = y), size = 0.75, alpha = 0.3)
      +
      ComplexUpset::geom_venn_circle(df_venn)
      +
      ggplot2::theme(
        legend.position = "none",
        text = ggplot2::element_text(face = "bold", color = "grey30")
      )
  )
  (
    (
      venn_highlighted +
        venn_highlight_regions(
          df = df_venn,
          regions =
            c(
              "adducts-isotopes",
              "adducts-fragments",
              "fragments-isotopes",
              "adducts-fragments-isotopes"
            ),
          color = "#484848"
        ) +
        ggplot2::labs(title = "Centroids with multiple annotations") |
        venn_highlighted +
          venn_highlight_regions(
            df = df_venn,
            regions =
              c(
                "isotopes",
                "adducts-isotopes",
                "fragments-isotopes",
                "adducts-fragments-isotopes"
              ),
            color = "#339966"
          ) +
          ggplot2::labs(title = "Centroids considered as isotopes")
    ) /
      (
        venn_highlighted +
          venn_highlight_regions(
            df = df_venn,
            regions =
              c("adducts", "adducts-fragments"),
            color = "#990000"
          ) +
          ggplot2::labs(title = "Centroids considered as adducts") |
          venn_highlighted +
            venn_highlight_regions(
              df = df_venn,
              regions = c("fragments"),
              color = "#006699"
            ) +
            ggplot2::labs(title = "Centroids considered as fragments")
      )
  )
}
