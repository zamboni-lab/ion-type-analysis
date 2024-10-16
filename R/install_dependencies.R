#' Install dependencies 1
#'
#' @param dependencies
#'
#' @return
#' @export
#'
#' @examples
install_dependencies_1 <- function(dependencies) {
  installed_packages <- rownames(installed.packages())

  if (!is.null(dependencies$bioconductor)) {
    dependencies$cran <- dependencies$cran |>
      append("BiocManager")
  }
  if (!is.null(dependencies$github)) {
    dependencies$cran <- dependencies$cran |>
      append("remotes")
  }

  installed_packages_cran <- dependencies$cran %in% installed_packages

  return(lapply(X = dependencies$cran[!installed_packages_cran], FUN = install.packages) |>
    invisible())
}

#' Install dependencies 2
#'
#' @param dependencies

#'
#' @return
#' @export
#'
#' @examples
install_dependencies_2 <- function(dependencies) {
  installed_packages <- rownames(installed.packages())
  installed_packages_cran <- dependencies$cran %in% installed_packages
  installed_packages_bioconductor <-
    dependencies$bioconductor %in% installed_packages
  installed_packages_github <- dependencies$github %in% installed_packages

  if (!is.null(dependencies$bioconductor)) {
    dependencies$cran <- dependencies$cran |>
      append("BiocManager")
  }
  if (!is.null(dependencies$github)) {
    dependencies$cran <- dependencies$cran |>
      append("remotes")
  }

  if (any(installed_packages_cran == FALSE)) {
    install.packages(dependencies$cran[!installed_packages_cran])
  }
  if (any(installed_packages_bioconductor == FALSE)) {
    BiocManager::install(dependencies$bioconductor[!installed_packages_bioconductor])
  }
  if (any(installed_packages_github == FALSE)) {
    lapply(X = dependencies$github[!installed_packages_github], FUN = remotes::install_github)
  }
}
