#' Venn prepare df
#'
#' @param df
#'
#' @return
#'
#' @examples
venn_prepare_df <- function(df) {
  return(data.frame(
    adducts = c(
      rep(FALSE, df$`non-redundant`),
      rep(TRUE, df$ao),
      rep(FALSE, df$co),
      rep(FALSE, df$io),
      rep(TRUE, df$aii),
      rep(TRUE, df$aic),
      rep(FALSE, df$iic),
      rep(TRUE, df$ei)
    ),
    fragments = c(
      rep(FALSE, df$`non-redundant`),
      rep(FALSE, df$ao),
      rep(TRUE, df$co),
      rep(FALSE, df$io),
      rep(TRUE, df$aii),
      rep(FALSE, df$aic),
      rep(TRUE, df$iic),
      rep(TRUE, df$ei)
    ),
    isotopes = c(
      rep(FALSE, df$`non-redundant`),
      rep(FALSE, df$ao),
      rep(FALSE, df$co),
      rep(TRUE, df$io),
      rep(FALSE, df$aii),
      rep(TRUE, df$aic),
      rep(TRUE, df$iic),
      rep(TRUE, df$ei)
    )
  ))
}
