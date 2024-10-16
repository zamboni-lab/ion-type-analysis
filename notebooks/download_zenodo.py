import argparse
import os
import zipfile

import requests
from bs4 import BeautifulSoup

ZENODO_BASE_URL = "https://zenodo.org"


def get_file_from_zenodo(url, filename):
    """Fetches the first URL that contains the given filename from the page at the provided URL."""
    response = requests.get(url)

    if response.status_code != 200:
        raise ValueError(f"Failed to access {url} (status code: {response.status_code})")

    soup = BeautifulSoup(response.content, "html.parser")

    urls = [a["href"] for a in soup.find_all("a", href=True) if filename in a["href"]]

    if not urls:
        raise ValueError(f"Can't get the link for '{filename}' on {url}")

    file_url = urls[0]

    if not file_url.startswith("http"):
        file_url = requests.compat.urljoin(ZENODO_BASE_URL, file_url)

    return file_url


def download_file(file_url, output_path):
    """Downloads the file from file_url and saves it to output_path."""
    response = requests.get(file_url)

    if response.status_code == 200:
        with open(output_path, "wb") as f:
            f.write(response.content)
        print(f"File downloaded successfully and saved to: {output_path}")
    else:
        raise ValueError(
            f"Failed to download the file from {file_url} (status code: {response.status_code})"
        )


def unzip_file(zip_path, extract_to):
    """Unzips the file to the specified directory."""
    if zipfile.is_zipfile(zip_path):
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(extract_to)
        print(f"File unzipped successfully to: {extract_to}")
    else:
        print(f"{zip_path} is not a valid zip file.")


def main():
    parser = argparse.ArgumentParser(
        description="Fetch a file link from a Zenodo page using a filename."
    )

    parser.add_argument("url", type=str, help="The Zenodo URL to fetch data from.")
    parser.add_argument("filename", type=str, help="The filename to search for in the file links.")
    parser.add_argument("output", type=str, help="Output file path to save the downloaded file.")
    parser.add_argument("--unzip", action="store_true", help="Flag to unzip the downloaded file.")

    args = parser.parse_args()

    try:
        file_url = get_file_from_zenodo(args.url, args.filename)

        output_dir = os.path.dirname(args.output)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)

        download_file(file_url, args.output)

        if args.unzip:
            unzip_file(args.output, output_dir)

    except ValueError as e:
        print(e)


if __name__ == "__main__":
    main()
