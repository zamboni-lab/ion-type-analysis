start <- Sys.time()

args <- commandArgs(trailingOnly = TRUE)

if (!("pkgload" %in% installed.packages())) {
  install.packages(c("pkgload"))
}

## Load necessary dependencies
pkgload::load_all()
install_dependencies_1(dependencies = dependencies)
install_dependencies_2(dependencies = dependencies)

## Import
### Standards
if (!"example=TRUE" %in% args) {
  df_standards_full <- path_dirs_standards |>
    import_dirs(fun = import_standards, columns = COLNAMES) |>
    tidytable::distinct()

  df_standards_full |>
    tidytable::mutate(tidytable::across(tidytable::where(is.list), as.character)) |>
    tidytable::fwrite(path_standards_full)

  df_standards_full |>
    tidytable::distinct(smiles) |>
    tidytable::fwrite(path_smiles)
}

end <- Sys.time()

message("Script finished in ", crayon::green(format(end - start)))
