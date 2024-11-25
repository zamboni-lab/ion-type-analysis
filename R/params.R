COLNAMES <- c(
  # "id",
  "area" = "area",
  "height" = "height",
  # "mz",
  "rt",
  "rt_min" = "rt_range:min",
  "rt_max" = "rt_range:max",
  "adduct_type" = "compound_db_identity:adduct",
  "smiles" = "compound_db_identity:smiles",
  "ms1" = "ion_type_analysis:ms1_signals",
  "msn" = "ion_type_analysis:msn_signals_all_precursors",
  "msn_row" = "ion_type_analysis:msn_signals_row",
  "fragment" = "ion_type_analysis:common_signals",
  "fragment_row" = "ion_type_analysis:common_signals_row",
  "adduct" = "ion_type_analysis:ms1_adducts_and_co",
  "isotope" = "ion_type_analysis:ms1_isotopes",
  "non-redundant" = "ion_type_analysis:ms1_unexplained",
  "non-redundant intensity" = "ion_type_analysis:ms1_unexplained_intensity_percent",
  "ms1_common_percent" = "ion_type_analysis:ms1_common_signals_percent",
  "msn_common_percent" = "ion_type_analysis:msn_common_signals_percent",
  "ms1_common_intensity_percent" = "ion_type_analysis:ms1_common_intensity_percent",
  "msn_common_intensity_percent" = "ion_type_analysis:msn_common_intensity_percent",
  "msn_common_intensity_percent_row" = "ion_type_analysis:msn_common_intensity_percent_row",
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

ENERGIES <- c("di_tof_pos", "di_tof_5_40ev_pos", "di_tof_5_60ev_pos")

EXAMPLES <- c("di_ot_pos", "di_tof_pos")

EXTENSION <- "png"

SIGNAL_TYPES <- c("adduct", "fragment", "isotope", "non-redundant")
SIGNAL_TYPES <- c("adduct", "fragment", "isotope")

SIGNAL_TYPES_FULL <- c("non-redundant", "ao", "io", "co", "aii", "aic", "iic", "ei")

THRESHOLDS <- c("di_tof_0_20ev_pos", "di_tof_pos", "di_tof_10_20ev_pos")

TRANSLATIONS <- c(
  "di_tof_pos" = "ToF",
  "di_ot_pos" = "OT",
  "di_ot_neg" = "OT (standards, negative)",
  "lc_at_pos" = "LC-Astral (NIST human fecal extract, positive)"
)
TRANSLATIONS_THRESHOLDS <-
  c(
    "di_tof_0_20ev_pos" = "DI-ToF, no threshold",
    "di_tof_pos" = "DI-ToF, lowest signal x5",
    "di_tof_10_20ev_pos" = "DI-ToF, lowest signal x10"
  )
TRANSLATIONS_ENERGIES <-
  c(
    "di_tof_pos" = "DI-ToF, 20eV",
    "di_tof_5_40ev_pos" = "DI-ToF, 40eV",
    "di_tof_5_60ev_pos" = "DI-ToF, 60eV"
  )
