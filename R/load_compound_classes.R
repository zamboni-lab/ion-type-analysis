#' Load compound classes
#'
#' @param files
#'
#' @return
#'
#' @examples
load_compound_classes <- function(files = c(
                                    "~/../../Volumes/T7_Shield/enamdisc_cleaned.tsv",
                                    "~/../../Volumes/T7_Shield/enammol_cleaned.tsv",
                                    "~/../../Volumes/T7_Shield/mcebio_cleaned.tsv",
                                    "~/../../Volumes/T7_Shield/mcedrug_cleaned.tsv",
                                    "~/../../Volumes/T7_Shield/mcescaf_cleaned.tsv",
                                    "~/../../Volumes/T7_Shield/nihnp_cleaned.tsv",
                                    "~/../../Volumes/T7_Shield/otavapep_cleaned.tsv"
                                  )) {
  ## COMMENT: A LOT MISSING FOR NOW
  classes <- files |>
    lapply(
      tidytable::fread,
      sep = "\t",
      select = c("smiles", "classyfire_superclass", "classyfire_class", "classyfire_subclass"),
      na.strings = c("", "NA")
    ) |>
    tidytable::bind_rows() |>
    tidytable::filter(!is.na(smiles)) |>
    tidytable::filter(!is.na(classyfire_superclass)) |>
    tidytable::select(smiles, classyfire_superclass, classyfire_class, classyfire_subclass) |>
    tidytable::distinct()
}
