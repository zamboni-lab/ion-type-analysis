import os
import urllib.request


# Function to download a script from a URL
def download_script(url, filename):
    try:
        print(f"Downloading {filename} from {url}...")
        urllib.request.urlretrieve(url, filename)
        print(f"Downloaded {filename}.")
    except Exception as e:
        print(f"Error downloading {filename}: {e}")


# URLs of the scripts
scripts = {
    "notebooks/sanitize_filename.py": "https://raw.githubusercontent.com/Wang-Bioinformatics-Lab/downloadpublicdata/main/bin/sanitize_filename.py",
    "notebooks/download_raw.py": "https://raw.githubusercontent.com/Wang-Bioinformatics-Lab/downloadpublicdata/main/bin/download_raw.py",
    "notebooks/download_public_data_usi.py": "https://raw.githubusercontent.com/Wang-Bioinformatics-Lab/downloadpublicdata/main/bin/download_public_data_usi.py",
}

# Download each script
for filename, url in scripts.items():
    download_script(url, filename)

import download_public_data_usi
import download_raw

# Import the functions from the downloaded scripts
import sanitize_filename

# Example usage of the functions
if __name__ == "__main__":
    try:
        download_public_data_usi.main()
    except NameError as e:
        print(f"Function not found: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")
