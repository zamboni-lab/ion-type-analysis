# ion-type-analysis

This repository contains the methods and code used to analyze ion types in <https://metabolomics.blog/2024/10/isf/>.

An overview of the process is illustrated below.

![](man/figures/ion_type_schema.png)

## Dependencies


### Software

To replicate our analysis, you will need the following software:

- The custom MZmine version available from the <https://github.com/Adafede/mzmine/tree/fragments_analysis> fork 
  - As it is not yet included in the latest MZmine version, building it might be _not so simple_... for details about installation, refer to <https://mzmine.github.io/mzmine_documentation/contribute_intellij.html>.
- [Python](https://www.python.org/) (>=3.10)
  - Poetry:
    ```bash
    curl -sSL https://install.python-poetry.org | python3 -
    ````
  - to install python dependencies:
    ```bash
    poetry install
    ```
- [R](https://www.r-project.org/) (>=4.3) (to reproduce the figures)

### Files

In case you just want to give a quick try, 6 example files are provided in `data/example/*.mzml`.

To replicate the full analysis, you will need the following datasets:

- Direct Injection ToF 20ev Positive: :warning: TO BE UPLOADED SOON :warning:
- Direct Injection ToF 40ev Positive: :warning: TO BE UPLOADED SOON :warning:
- Direct Injection ToF 60ev Positive: :warning: TO BE UPLOADED SOON :warning:
- Direct Injection Obitrap Positive: [zenodo.13890851](https://doi.org/10.5281/zenodo.13890851)
- Direct Injection Obitrap Negative: [zenodo.13890851](https://doi.org/10.5281/zenodo.13890851)
- Liquid Chromatography Astral Positive: [MSV000093526](https://massive.ucsd.edu/ProteoSAFe/dataset.jsp?task=5b9076c6cd134284806672033569996e)

For the files on MASSIVE, a convenience script using <https://github.com/Wang-Bioinformatics-Lab/downloadpublicdata> is available:

```bash
poetry run python3 ./notebooks/download_massive.py ./data/MSV000093526.txt ./data/source/MSV000093526 ./data/source/MSV000093526/MSV000093526_summary.tsv
```

For the files on Zenodo, a convenience script is available:

```bash
poetry run python3 ./notebooks/download_zenodo.py https://doi.org/10.5281/zenodo.13890851 20231123_mzml_mce_scaffold_positive.zip ./data/source/20231123_mzml_mce_scaffold_positive.zip --unzip

poetry run python3 ./notebooks/download_zenodo.py https://doi.org/10.5281/zenodo.13890851 20231123_mzml_mce_scaffold_negative.zip ./data/source/20231123_mzml_mce_scaffold_negative.zip --unzip
```

## Performing the analysis

To use the MZmine ion type analysis module:

### Example

```bash
# NOTE: `mzmine-dev` refers to the MZmine executable built from the above mentioned branch
mzmine-dev -batch ".mzmine/batch/di_tof_example.mzbatch" -i "./data/example/*.mzML" -o "./data/example/di_tof_10_20ev_pos/{}"
```

This will give you the results for the example file.

### Full

To reproduce the full results:

:warning: not fully working for now because of the required libraries for standards annotation!

:warning: not fully working for now because of DI-ToF dataset not being available!

```bash
mzmine-dev -batch ".mzmine/batch/di_ot_2.5_neg.mzbatch" -i "./data/source/20231123_mzml_mce_scaffold_negative/*.mzML" -o "./data/di_ot_2.5_neg/{}"
mzmine-dev -batch ".mzmine/batch/di_ot_2.5_pos.mzbatch" -i "./data/source/20231123_mzml_mce_scaffold_positive/*.mzML" -o "./data/di_ot_2.5_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_0_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/20/*.mzML" -o "./data/di_tof_0_20ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_10_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/20/*.mzML" -o "./data/di_tof_10_20ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_100_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/20/*.mzML" -o "./data/di_tof_100_20ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_0_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/40/*.mzML" -o "./data/di_tof_0_40ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_10_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/40/*.mzML" -o "./data/di_tof_10_40ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_100_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/40/*.mzML" -o "./data/di_tof_100_40ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_0_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/60/*.mzML" -o "./data/di_tof_0_60ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_10_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/60/*.mzML" -o "./data/di_tof_10_60ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/di_tof_100_pos.mzbatch" -i "/Volumes/biol_imsb_sauer_1/users/Adriano/01_projects/02_library/02_raw_data/inhouse/01_zeno/all_converted/CID/60/*.mzML" -o "./data/di_tof_100_60ev_pos/{}"
mzmine-dev -batch ".mzmine/batch/lc_at_5_pos.mzbatch" -i "./data/source/MSV000093526/*.mzML" -o "./data/lc_at_5_pos/{}"
```

#### Standards annotation

To speed up the process on the large sets, we first detect features corresponding to the injected compounds only (we still link all other ones later on).
For this, you'll need the library files available in :warning: `TODO` :warning: to filter the number of features on which the analysis is performed.
This is absolutely not required (so you can apply the methodology on complex, unknown samples), the analysis will just take longer.

#### Known issues and fixes

Some of the negative runs in the DI-Orbitrap dataset do not contain any matching scan and would cause issues if not removed:

```bash
poetry run python3 ./notebooks/remove_empty.py -d ./data/di_ot_2.5_neg
```

## Reproducing the figures

You can reproduce the figures by using the following command:

```bash
# NOTE: remove the `--args example=TRUE` if you have all datasets
R < ./inst/scripts/plot_figures.R --no-save --args example=TRUE
```

## Acknowledgments

Listed alphabetically below are the individuals whose contributions—whether through sharing ideas, code, or data—have been essential to the current analysis:
- [Corinna](https://github.com/corinnabrungs)
- [Mario](https://orcid.org/0000-0003-2125-4184)
- [Robin](https://github.com/robinschmid)
- [Steffen](https://github.com/SteffenHeu)
- [Yasin](https://github.com/YasinEl)

:warning: TODO :warning:

Someone else missing?

## Contact

:warning: TODO :warning:
