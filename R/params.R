COLNAMES <- c(
  # "id",
  "area" = "area",
  "height" = "height",
  # "mz",
  "rt",
  "rt_min" = "rt_range:min",
  "rt_max" = "rt_range:max",
  "smiles" = "compound_db_identity:smiles",
  "ms1" = "ion_type_analysis:ms1_signals",
  "msn" = "ion_type_analysis:msn_signals_all_precursors",
  "fragment" = "ion_type_analysis:common_signals",
  "adduct" = "ion_type_analysis:ms1_adducts_and_co",
  "isotope" = "ion_type_analysis:ms1_isotopes",
  "non-redundant" = "ion_type_analysis:ms1_unexplained",
  "non-redundant intensity" = "ion_type_analysis:ms1_unexplained_intensity_percent",
  "ms1_common_percent" = "ion_type_analysis:ms1_common_signals_percent",
  "msn_common_percent" = "ion_type_analysis:msn_common_signals_percent",
  "ms1_common_intensity_percent" = "ion_type_analysis:ms1_common_intensity_percent",
  "msn_common_intensity_percent" = "ion_type_analysis:msn_common_intensity_percent",
  "fragmented" = "ion_type_analysis:precursor_ions_count",
  "fragmented_percent" = "ion_type_analysis:precursor_ions_in_ms1_percent",
  "fragmented_intensity_percent" = "ion_type_analysis:precursor_ions_intensity_in_ms1_percent",
  "ao" = "ion_type_analysis:ms1_ao",
  "io" = "ion_type_analysis:ms1_io",
  "co" = "ion_type_analysis:ms1_co",
  "aii" = "ion_type_analysis:ms1_aii",
  "aic" = "ion_type_analysis:ms1_aic",
  "iic" = "ion_type_analysis:ms1_iic",
  "ei" = "ion_type_analysis:ms1_ei"
)

EXAMPLES <- c(
  "di_ot_5_pos",
  "di_ot_5_neg",
  "di_tof_5_20ev_pos",
  "lc_at_5_pos"
)

EXTENSION <- "png"

SIGNAL_TYPES <- c("adduct", "fragment", "isotope", "non-redundant")

SIGNAL_TYPES_FULL <- c("non-redundant", "ao", "io", "co", "aii", "aic", "iic", "ei")
