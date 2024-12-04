#' Reformat table
#'
#' @param table
#' @param file
#' @param remove_above
#' @param diff_min
#' @param diffs_to_keep
#' @param fragments_to_exclude
#'
#' @return
#'
#' @examples
reformat_table <- function(table,
                           file,
                           remove_above = TRUE,
                           diff_min = -4.5,
                           diffs_to_keep = list(c(-4.03, -3.99), c(-2.03, -1.99)),
                           fragments_to_exclude = list(c(143.70, 143.74), c(173.50, 173.54))) {
  table <- table |>
    tidytable::select(-tidytable::contains("datafile")) |>
    tidytable::mutate(tidytable::across(
      tidytable::contains("ion_type_analysis"),
      .fns = function(x) {
        x |>
          gsub(
            pattern = "\n",
            replacement = "",
            fixed = TRUE
          ) |>
          strsplit(split = ", ") |>
          lapply(as.numeric)
      }
    ))
  colnames(table) <- colnames(table) |>
    gsub(
      pattern = "ion_type_analysis:",
      replacement = "",
      fixed = TRUE
    )
  colnames(table) <- colnames(table) |>
    gsub(
      pattern = "compound_db_identity:",
      replacement = "",
      fixed = TRUE
    )
  table_2 <- table |>
    tidytable::bind_rows(
      tibble::tibble(
        isotopes_mzs = list(),
        msn_mzs_scan = list(),
        msn_mzs_row = list(),
        common_mzs_scan = list(),
        common_mzs_row = list(),
        common_mzs_row_filtered = list(),
        fragmented_mzs = list(),
        adducts_mzs = list(),
        adduct = list(),
        precursor_mz = 0
      )
    ) |>
    tidytable::rename(adduct_type = adduct) |>
    tidytable::rename(common_mzs_row_old = common_mzs_row) |>
    tidytable::rename(common_mzs_row = common_mzs_row_filtered) |>
    tidytable::mutate(
      common_diffs_row = tidytable::map2(
        .x = common_mzs_row,
        .y = precursor_mz,
        .f = function(x, y) {
          x - y
        }
      ),
      common_diffs_scan = tidytable::map2(
        .x = common_mzs_scan,
        .y = precursor_mz,
        .f = function(x, y) {
          x - y
        }
      )
    )
  if (remove_above) {
    table_2 <- table_2 |>
      tidytable::mutate(
        common_mzs_row_original = common_mzs_row,
        common_mzs_scan_original = common_mzs_scan,
        common_diffs_row_original = common_diffs_row,
        common_diffs_scan_original = common_diffs_scan
      ) |>
      tidytable::mutate(
        common_mzs_row = tidytable::map2(
          .x = common_mzs_row,
          .y = common_diffs_row,
          .f = filter_fragments,
          diff_min = diff_min,
          diffs_to_keep = diffs_to_keep,
          fragments_to_exclude = fragments_to_exclude
        ),
        common_mzs_scan = tidytable::map2(
          .x = common_mzs_scan,
          .y = common_diffs_scan,
          .f = filter_fragments,
          diff_min = diff_min,
          diffs_to_keep = diffs_to_keep,
          fragments_to_exclude = fragments_to_exclude
        ),
        common_mzs_row_above = tidytable::map2(
          .x = common_mzs_row,
          .y = common_diffs_row,
          .f = filter_fragments,
          diff_min = diff_min,
          diffs_to_keep = diffs_to_keep,
          fragments_to_exclude = fragments_to_exclude,
          invert_selection = TRUE
        ),
        common_mzs_scan_above = tidytable::map2(
          .x = common_mzs_scan,
          .y = common_diffs_scan,
          .f = filter_fragments,
          diff_min = diff_min,
          diffs_to_keep = diffs_to_keep,
          fragments_to_exclude = fragments_to_exclude,
          invert_selection = TRUE
        )
      ) |>
      ## On the diffs themselves
      tidytable::mutate(
        common_diffs_row = tidytable::map(
          .x = common_diffs_row,
          .f = function(x, diff_min) {
            x[x <= diff_min]
          },
          diff_min = diff_min
        ),
        common_diffs_scan = tidytable::map(
          .x = common_diffs_scan,
          .f = function(x, diff_min) {
            x[x <= diff_min]
          },
          diff_min = diff_min
        ),
        common_diffs_row_above = tidytable::map(
          .x = common_diffs_row,
          .f = function(x, diff_min) {
            x[x > diff_min]
          },
          diff_min = diff_min
        ),
        common_diffs_scan_above = tidytable::map(
          .x = common_diffs_scan,
          .f = function(x, diff_min) {
            x[x > diff_min]
          },
          diff_min = diff_min
        )
      )
  }
  table_2 <- table_2 |>
    ## Count
    tidytable::mutate(
      aic_mzs = tidytable::map2(
        .x = adducts_mzs,
        .y = common_mzs_scan,
        .f = function(x, y) {
          x[x %in% y]
        }
      ),
      aii_mzs = tidytable::map2(
        .x = adducts_mzs,
        .y = isotopes_mzs,
        .f = function(x, y) {
          x[x %in% y]
        }
      ),
      iic_mzs = tidytable::map2(
        .x = isotopes_mzs,
        .y = common_mzs_scan,
        .f = function(x, y) {
          x[x %in% y]
        }
      ),
      anc_mzs = tidytable::map2(
        .x = adducts_mzs,
        .y = common_mzs_scan,
        .f = function(x, y) {
          x[!x %in% y]
        }
      ),
      cna_mzs = tidytable::map2(
        .x = common_mzs_scan,
        .y = adducts_mzs,
        .f = function(x, y) {
          x[!x %in% y]
        }
      ),
      ina_mzs = tidytable::map2(
        .x = isotopes_mzs,
        .y = adducts_mzs,
        .f = function(x, y) {
          x[!x %in% y]
        }
      )
    ) |>
    tidytable::mutate(
      ei_mzs = tidytable::map2(
        .x = aic_mzs,
        .y = isotopes_mzs,
        .f = function(x, y) {
          x[x %in% y]
        }
      ),
      ao_mzs = tidytable::map2(
        .x = anc_mzs,
        .y = isotopes_mzs,
        .f = function(x, y) {
          x[!x %in% y]
        }
      ),
      co_mzs = tidytable::map2(
        .x = cna_mzs,
        .y = isotopes_mzs,
        .f = function(x, y) {
          x[!x %in% y]
        }
      ),
      io_mzs = tidytable::map2(
        .x = ina_mzs,
        .y = common_mzs_scan,
        .f = function(x, y) {
          x[!x %in% y]
        }
      )
    ) |>
    tidytable::mutate(
      ms1 = tidytable::map_int(ms1_mzs, length),
      msn = tidytable::map_int(msn_mzs_scan, length),
      msn_row = tidytable::map_int(msn_mzs_row, length),
      fragment = tidytable::map_int(common_mzs_scan, length),
      fragment_row = tidytable::map_int(common_mzs_row, length),
      adduct = tidytable::map_int(adducts_mzs, length),
      fragmented = tidytable::map_int(fragmented_mzs, length),
      isotope = tidytable::map_int(isotopes_mzs, length),
      ao = tidytable::map_int(ao_mzs, length),
      io = tidytable::map_int(io_mzs, length),
      co = tidytable::map_int(co_mzs, length),
      aic = tidytable::map_int(aic_mzs, length),
      aii = tidytable::map_int(aii_mzs, length),
      iic = tidytable::map_int(iic_mzs, length),
      ei = tidytable::map_int(ei_mzs, length)
    ) |>
    tidytable::mutate(
      common_intensities_row_broad = tidytable::pmap(
        .l = list(
          ms1_intensities = ms1_intensities,
          ms1_mzs = ms1_mzs,
          common_mzs_row = common_mzs_row
        ),
        .f = function(ms1_intensities,
                      ms1_mzs,
                      common_mzs_row) {
          ms1_intensities[ms1_mzs %in% common_mzs_row]
        }
      ),
      common_intensities_row_narrow = tidytable::pmap(
        .l = list(
          ms1_intensities = ms1_intensities,
          ms1_mzs = ms1_mzs,
          common_mzs_row = common_mzs_row,
          adducts_mzs = adducts_mzs,
          isotopes_mzs = isotopes_mzs
        ),
        .f = function(ms1_intensities,
                      ms1_mzs,
                      common_mzs_row,
                      adducts_mzs,
                      isotopes_mzs) {
          ms1_intensities[ms1_mzs %in% common_mzs_row &
            !ms1_mzs %in% adducts_mzs &
            !ms1_mzs %in% isotopes_mzs]
        }
      ),
      common_intensities_scan_broad = tidytable::pmap(
        .l = list(
          ms1_intensities = ms1_intensities,
          ms1_mzs = ms1_mzs,
          common_mzs_scan = common_mzs_scan
        ),
        .f = function(ms1_intensities,
                      ms1_mzs,
                      common_mzs_scan) {
          ms1_intensities[ms1_mzs %in% common_mzs_scan]
        }
      ),
      common_intensities_scan_narrow = tidytable::pmap(
        .l = list(
          ms1_intensities = ms1_intensities,
          ms1_mzs = ms1_mzs,
          common_mzs_scan = common_mzs_scan,
          adducts_mzs = adducts_mzs,
          isotopes_mzs = isotopes_mzs
        ),
        .f = function(ms1_intensities,
                      ms1_mzs,
                      common_mzs_scan,
                      adducts_mzs,
                      isotopes_mzs) {
          ms1_intensities[ms1_mzs %in% common_mzs_scan &
            !ms1_mzs %in% adducts_mzs &
            !ms1_mzs %in% isotopes_mzs]
        }
      ),
      fragmented_intensities = tidytable::pmap(
        .l = list(
          ms1_intensities = ms1_intensities,
          ms1_mzs = ms1_mzs,
          fragmented_mzs = fragmented_mzs
        ),
        .f = function(ms1_intensities,
                      ms1_mzs,
                      fragmented_mzs) {
          ms1_intensities[ms1_mzs %in% fragmented_mzs]
        }
      ),
      `non-redundant_row_mzs` = tidytable::pmap(
        .l = list(
          ms1_mzs = ms1_mzs,
          common_mzs_row = common_mzs_row,
          # common_mzs_row_above = common_mzs_row_above,
          adducts_mzs = adducts_mzs,
          isotopes_mzs = isotopes_mzs
        ),
        .f = function(ms1_mzs,
                      common_mzs_row,
                      # common_mzs_row_above,
                      adducts_mzs,
                      isotopes_mzs) {
          ms1_mzs[!ms1_mzs %in% common_mzs_row &
            # !ms1_mzs %in% common_mzs_row_above &
            !ms1_mzs %in% adducts_mzs &
            !ms1_mzs %in% isotopes_mzs]
        }
      ),
      `non-redundant_mzs` = tidytable::pmap(
        .l = list(
          ms1_mzs = ms1_mzs,
          common_mzs_scan = common_mzs_scan,
          # common_mzs_scan_above = common_mzs_scan_above,
          adducts_mzs = adducts_mzs,
          isotopes_mzs = isotopes_mzs
        ),
        .f = function(ms1_mzs,
                      common_mzs_scan,
                      # common_mzs_scan_above
                      adducts_mzs,
                      isotopes_mzs) {
          ms1_mzs[!ms1_mzs %in% common_mzs_scan &
            # !ms1_mzs %in% common_mzs_scan_above &
            !ms1_mzs %in% adducts_mzs &
            !ms1_mzs %in% isotopes_mzs]
        }
      )
    ) |>
    tidytable::mutate(
      highest_fragment_intensity = tidytable::map_dbl(
        .x = common_intensities_row_narrow,
        .f = function(x,
                      n = 1) {
          tidytable::nth(sort(x, decreasing = TRUE), n)
        }
      ),
      second_fragment_intensity = tidytable::map_dbl(
        .x = common_intensities_row_narrow,
        .f = function(x,
                      n = 2) {
          tidytable::nth(sort(x, decreasing = TRUE), n)
        }
      ),
      third_fragment_intensity = tidytable::map_dbl(
        .x = common_intensities_row_narrow,
        .f = function(x,
                      n = 3) {
          tidytable::nth(sort(x, decreasing = TRUE), n)
        }
      ),
      percent_fragmented_intensity = tidytable::map2_dbl(
        .x = fragmented_intensities,
        .y = ms1_intensities,
        .f = function(x, y) {
          sum(x) / sum(y)
        }
      ),
      percent_fragments_intensity_broad = tidytable::map2_dbl(
        .x = common_intensities_row_broad,
        .y = height,
        .f = function(x, y) {
          mean(x / y)
        }
      ),
      percent_fragments_intensity_narrow = tidytable::map2_dbl(
        .x = common_intensities_row_narrow,
        .y = height,
        .f = function(x, y) {
          mean(x / y)
        }
      ),
      `non-redundant_row` = tidytable::map_int(`non-redundant_row_mzs`, length),
      `non-redundant` = tidytable::map_int(`non-redundant_mzs`, length),
      count_fragments_row = tidytable::map_int(common_intensities_row_narrow, length),
      count_fragments_row_broad = tidytable::map_int(common_intensities_row_broad, length),
      count_fragments_broad = tidytable::map_int(common_intensities_scan_broad, length)
    ) |>
    tidytable::mutate(filename = file, cutoff = basename(dirname(file))) |>
    tidytable::mutate(adduct_type = as.character(adduct_type)) |>
    tidytable::select(tidytable::any_of(
      c(
        "id",
        "area",
        "rt",
        "mz_range:min",
        "mz_range:max",
        "fragment_scans",
        "compound_db_identity",
        "compound_name",
        "compound_annotation_score",
        "adduct_type",
        "smiles",
        "precursor_mz",
        "mz_diff_ppm",
        "neutral_mass",
        "rt_range:min",
        "rt_range:max",
        "mz",
        "intensity_range:min",
        "intensity_range:max",
        "height",
        "ms1",
        "msn",
        "msn_row",
        "fragment",
        "fragment_row",
        "adduct",
        "fragmented",
        "isotope",
        "non-redundant_row",
        "non-redundant",
        "common_intensities_row_narrow",
        "highest_fragment_intensity",
        "second_fragment_intensity",
        "third_fragment_intensity",
        "percent_fragmented_intensity",
        "percent_fragments_intensity_broad",
        "percent_fragments_intensity_narrow",
        "count_fragments_row",
        "count_fragments_row_broad",
        "count_fragments",
        "count_fragments_broad",
        "filename",
        "cutoff",
        "common_mzs_row",
        "common_diffs_row",
        "ao",
        "io",
        "co",
        "aic",
        "aii",
        "iic",
        "ei"
      )
    ))
}
