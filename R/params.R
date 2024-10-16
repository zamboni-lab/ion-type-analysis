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
  "ms2" = "ion_type_analysis:ms2_signals_all_precursors",
  "fragments" = "ion_type_analysis:common_signals",
  "adducts" = "ion_type_analysis:ms1_adducts_and_co",
  "isotopes" = "ion_type_analysis:ms1_isotopes",
  "unexplained" = "ion_type_analysis:ms1_unexplained",
  "unexplained_intensity_percent" = "ion_type_analysis:ms1_unexplained_intensity_percent",
  "ms1_common_percent" = "ion_type_analysis:ms1_common_signals_percent",
  "ms2_common_percent" = "ion_type_analysis:ms2_common_signals_percent",
  "ms1_common_intensity_percent" = "ion_type_analysis:ms1_common_intensity_percent",
  "ms2_common_intensity_percent" = "ion_type_analysis:ms2_common_intensity_percent",
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
  "di_ot_2.5_pos",
  "di_tof_10_20ev_pos",
  "lc_at_5_pos"
)

EXTENSION <- "png"

SIGNAL_TYPES <- c("adducts", "fragments", "isotopes", "unexplained")

SIGNAL_TYPES_FULL <- c("unexplained", "ao", "io", "co", "aii", "aic", "iic", "ei")
