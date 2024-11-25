from multiprocessing import Pool, cpu_count

import polars
from rdkit import Chem, RDLogger
from rdkit.Chem import MolFromSmarts
from tqdm import tqdm

# Suppress RDKit warnings
RDLogger.DisableLog("rdApp.*")

input_csv = "./data/dark_smiles.csv"
output_csv = "./data/dark_smiles_processed.csv"

# SMARTS patterns
OH_pattern = MolFromSmarts("[OX2H]")
COOH_pattern = MolFromSmarts("[CX3](=O)[OX2H1]")
amine_pattern = MolFromSmarts("[NX3H2]")
phosphate_pattern = MolFromSmarts("OP(=O)(O)O")
sulphate_pattern = MolFromSmarts("OS(=O)(=O)O")


def count_functional_groups(smiles):
    mol = Chem.MolFromSmiles(smiles)
    if mol is None:
        return None

    return {
        "smiles": smiles,
        "num_OH": len(mol.GetSubstructMatches(OH_pattern)),
        "num_COOH": len(mol.GetSubstructMatches(COOH_pattern)),
        "num_amine": len(mol.GetSubstructMatches(amine_pattern)),
        "num_phosphate": len(mol.GetSubstructMatches(phosphate_pattern)),
        "num_sulphate": len(mol.GetSubstructMatches(sulphate_pattern)),
    }


def process_csv(input_csv, output_csv):
    df = polars.read_csv(input_csv)

    if "smiles" not in df.columns:
        raise ValueError("Input CSV must contain a 'smiles' column.")

    unique_smiles = df["smiles"].unique().to_list()

    num_processes = max(cpu_count() - 1, 1)
    print(f"Using {num_processes} processes.")

    pbar = tqdm(total=len(unique_smiles), desc="Processing SMILES")
    with Pool(num_processes) as pool:
        results = []
        for result in pool.imap_unordered(count_functional_groups, unique_smiles):
            if result is not None:
                results.append(result)
            pbar.update()

    pbar.close()

    results_df = polars.DataFrame(results)

    merged_df = df.join(results_df, on="smiles", how="left")

    merged_df.write_csv(output_csv)
    print(f"Data saved to '{output_csv}'")


if __name__ == "__main__":
    process_csv(input_csv, output_csv)
