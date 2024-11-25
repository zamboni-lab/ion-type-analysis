import argparse
import glob
import logging
import os
from typing import List, Optional

import polars
from msbuddy import assign_subformula
from rdkit.Chem import MolFromSmiles, rdMolDescriptors

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


class MSDataProcessor:
    def __init__(self, directory: str):
        """
        Initialize the MS data processor.

        Args:
            directory (str): Path to the directory containing CSV files
        """
        self.directory = directory

    @staticmethod
    def smiles_to_formula(smiles: str) -> Optional[str]:
        if not isinstance(smiles, str):
            return None
        try:
            mol = MolFromSmiles(smiles)
            if mol:
                return rdMolDescriptors.CalcMolFormula(mol)
            return None
        except Exception as e:
            logging.warning(f"Error converting SMILES to formula: {e}")
            return None

    @staticmethod
    def parse_mz_array(mz_str: str) -> List[float]:
        if not mz_str:
            # logging.warning("Received None or empty m/z string.")
            return []  # Handle empty string case
        try:
            values = mz_str.strip("[]").split(",")
            return [float(x.strip()) for x in values if x.strip()]
        except Exception as e:
            logging.warning(f"Error parsing m/z array: {e}")
            return mz_str  # Return original string if parsing fails

    def process_row(self, row: dict) -> str:
        try:
            ms2_mz = self.parse_mz_array(row["ion_type_analysis:common_mzs_row"])
            smiles = row["compound_db_identity:smiles"]
            adduct = row["compound_db_identity:adduct"]

            if not ms2_mz or not smiles or not adduct:
                # logging.warning(f"Received empty m/z or SMILES or adduct")
                return str(ms2_mz)  # Return the original mzs if incomplete information

            precursor_formula = self.smiles_to_formula(smiles)
            if not precursor_formula:
                # logging.warning(f"Received empty precursor formula")
                return str(ms2_mz)  # Return the original mzs if formula conversion fails

            subformula_list = assign_subformula(
                ms2_mz=ms2_mz,
                precursor_formula=precursor_formula,
                adduct=adduct,
                ms2_tol=0.02,
                ppm=False,
                dbe_cutoff=0.0,
            )

            filtered_array = [
                ms2_mz[subformula.idx]
                for subformula in subformula_list
                if hasattr(subformula, "subform_list") and subformula.subform_list
            ]

            return f"{', '.join(f'{x:.4f}' for x in filtered_array)}"

        except Exception as e:
            logging.error(f"Error processing row: {e}")
            return str(ms2_mz)  # Return the original mzs if any error occurs

    def process_files(self):
        """
        Process all CSV files in the directory and replace them.
        """
        try:
            csv_files = glob.glob(os.path.join(self.directory, "*.csv"))
            if not csv_files:
                logging.warning("No CSV files found in the directory.")
                return

            for file_path in csv_files:
                logging.info(f"Processing file: {file_path}")

                try:
                    df = polars.read_csv(file_path)
                    # Check for required columns
                    required_columns = [
                        "ion_type_analysis:common_mzs_row",
                        "compound_db_identity:smiles",
                        "compound_db_identity:adduct",
                    ]
                    if not set(required_columns).issubset(df.columns):
                        # logging.warning(f"Missing required columns in file: {file_path}")
                        continue

                    df = df.fill_null("")
                    df = df.with_columns(
                        polars.col("ion_type_analysis:common_mzs_row")
                        .cast(str)
                        .alias("ion_type_analysis:common_mzs_row"),
                        polars.col("compound_db_identity:smiles")
                        .cast(str)
                        .alias("compound_db_identity:smiles"),
                        polars.col("compound_db_identity:adduct")
                        .cast(str)
                        .alias("compound_db_identity:adduct"),
                    )

                    df = df.with_columns(
                        polars.struct(
                            [
                                "ion_type_analysis:common_mzs_row",
                                "compound_db_identity:smiles",
                                "compound_db_identity:adduct",
                            ]
                        )
                        .map_elements(self.process_row)
                        .alias("ion_type_analysis:common_mzs_row_filtered")
                    )

                    df.write_csv(file_path)
                    logging.info(f"File successfully processed and saved: {file_path}")
                except Exception as e:
                    logging.error(f"Error processing file {file_path}: {e}")

        except Exception as e:
            logging.error(f"Error processing files in directory: {e}")
            raise


def main():
    parser = argparse.ArgumentParser(
        description="Process all CSV files in a directory by filtering m/z arrays based on subformula assignment."
    )
    parser.add_argument(
        "-d",
        "--directory",
        required=True,
        type=str,
        help="Path to the directory containing CSV files",
    )
    args = parser.parse_args()

    processor = MSDataProcessor(args.directory)
    processor.process_files()


if __name__ == "__main__":
    main()
