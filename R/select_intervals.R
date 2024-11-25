#' Select intervals
#'
#' @param df
#'
#' @return A list containing the best filtered df and best summed height
#'
#' @examples
select_intervals <- function(df) {
  last_rt_max <- -Inf

  purrr:::accumulate(1:nrow(df), function(acc, i) {
    # If the current row doesn't overlap, add it to the result
    if (df$`rt_range:min`[i] >= acc$last_rt_max) {
      acc$selected_intervals[[length(acc$selected_intervals) + 1]] <- df[i, ]
      acc$last_rt_max <- df$`rt_range:max`[i]
    }
    return(acc)
  }, .init = list(selected_intervals = list(), last_rt_max = last_rt_max))[[nrow(df)]]$selected_intervals
}
