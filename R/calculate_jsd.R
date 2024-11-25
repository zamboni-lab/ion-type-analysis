#' Calculate Jensen-Shannon divergence
#'
#' @param intensities1
#' @param intensities2
#'
#' @return
#'
#' @examples
calculate_jsd <- function(intensities1, intensities2) {
  # Ensure the input vectors are sorted
  P.count <- sort(intensities1)
  Q.count <- sort(intensities2)
  # Combine into a matrix for philentropy::JSD
  x.count <- rbind(P.count, Q.count)
  # Calculate JSD
  jsd_value <- philentropy::JSD(x.count, est.prob = "empirical")
  return(jsd_value[[1]])
}
