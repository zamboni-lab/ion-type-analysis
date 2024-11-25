#' Import dirs
#'
#' @include reformat_table.R
#'
#' @param mzs
#' @param bin_size
#' @param min_mz
#' @param max_mz
#' @param threshold
#' @param y_min
#' @param y_max
#' @param mutate
#' @param title
#'
#' @return
#'
#' @examples
plot_bins <- function(mzs,
                      bin_size = 1,
                      min_mz = -180.5,
                      max_mz = 50.5,
                      threshold = 10,
                      y_min = 0,
                      y_max = 70,
                      mutate = TRUE,
                      title = NULL) {
  breaks <- seq(min_mz, max_mz, by = bin_size)
  bins <- cut(
    as.numeric(mzs),
    breaks = breaks,
    include.lowest = TRUE,
    right = FALSE
  ) |> table()

  df <- bins |>
    data.frame()

  if (mutate) {
    df <- df |>
      # tidytable::filter(n > 3) |>
      tidytable::mutate(bin_center = (as.numeric(
        sub("\\[([^,]+),.*", "\\1", df$Var1)
      ) +
        as.numeric(
          sub("\\[([^,]+),(.*)(\\)|\\])", "\\2", df$Var1)
        )) / 2) |>
      tidytable::distinct()
  }

  above <- subset(df, Freq >= threshold)

  df |>
    ggplot2::ggplot(mapping = ggplot2::aes(x = bin_center, y = Freq)) +
    ggplot2::geom_col() +
    ggrepel::geom_label_repel(
      data = above,
      ggplot2::aes(x = bin_center, y = Freq, label = bin_center)
    ) +
    ggplot2::ylim(c(y_min, y_max)) +
    ggplot2::theme_minimal(base_size = 15) +
    ggplot2::ggtitle(title)
}
