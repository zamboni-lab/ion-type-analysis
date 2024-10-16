#' Venn highlight regions
#'
#' @param df
#' @param regions
#' @param color
#'
#' @return
#' @export
#'
#' @examples
venn_highlight_regions <- function(df, regions, color = "yellow") {
  ComplexUpset::scale_fill_venn_mix(
    df,
    guide = "none",
    highlight = regions,
    active_color = rep(color, length(regions)),
    inactive_color = "NA"
  )
}
