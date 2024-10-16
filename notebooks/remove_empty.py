import argparse
import os

parser = argparse.ArgumentParser(
    description="Remove all files with only a single line in the specified directory."
)
parser.add_argument("-d", type=str, help="Path to the directory")

args = parser.parse_args()
directory = args.d

for filename in os.listdir(directory):
    file_path = os.path.join(directory, filename)

    if os.path.isfile(file_path):
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()

            if len(lines) == 1:
                os.remove(file_path)
                print(f"Removed: {file_path}")
