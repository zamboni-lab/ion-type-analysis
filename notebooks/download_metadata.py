import argparse
import os
import urllib.request

def download_metadata(raw_url, output_path):
    """
    Downloads a file from a given GitHub raw URL to the specified output path.

    Parameters:
        raw_url (str): The raw GitHub URL of the file to download.
        output_path (str): The path where the downloaded file will be saved.
    """
    try:
        print(f"Downloading metadata from {raw_url} to {output_path}...")
        # Ensure the output directory exists
        output_dir = os.path.dirname(output_path)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        # Download the file
        urllib.request.urlretrieve(raw_url, output_path)
        print(f"Metadata downloaded and saved to: {output_path}")
    except Exception as e:
        raise ValueError(f"Error downloading metadata: {e}")

def main():
    parser = argparse.ArgumentParser(
        description="Download metadata from a raw GitHub URL and save it to the specified location."
    )

    parser.add_argument("url", type=str, help="The raw GitHub URL of the file to download.")
    parser.add_argument("output", type=str, help="The output file path to save the downloaded file.")

    args = parser.parse_args()

    try:
        download_metadata(args.url, args.output)
    except ValueError as e:
        print(e)

if __name__ == "__main__":
    main()
