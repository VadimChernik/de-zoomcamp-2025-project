from google.cloud import storage
from google.cloud.storage import transfer_manager
from pathlib import Path

# If you authenticated through the GCP SDK you can comment out these two lines
CREDENTIALS_FILE = "/workspaces/de-zoomcamp-2025-project/key/de-zoomcamp-2025-gcp.json"  
storage_client = storage.Client.from_service_account_json(CREDENTIALS_FILE)

# The ID of your GCS bucket
bucket_name = "bikeshare-bucket-449913-n7"

# The directory on your computer to upload. Files in the directory and its
# subdirectories will be uploaded.
source_directory="/workspaces/de-zoomcamp-2025-project/data/"

def upload_directory_with_transfer_manager(bucket_name, source_directory, workers=8):
    
    bucket = storage_client.bucket(bucket_name)

    # Generate a list of paths (in string form) relative to the `directory`.
    # This can be done in a single list comprehension, but is expanded into
    # multiple lines here for clarity.

    # First, recursively get all files in `directory` as Path objects.
    directory_as_path_obj = Path(source_directory)
    paths = directory_as_path_obj.rglob("*")

    # Filter so the list only includes files, not directories themselves.
    file_paths = [path for path in paths if path.is_file()]

    # These paths are relative to the current working directory. Next, make them
    # relative to `directory`
    relative_paths = [path.relative_to(source_directory) for path in file_paths]

    # Finally, convert them all to strings.
    string_paths = [str(path) for path in relative_paths]

    print("Found {} files.".format(len(string_paths)))

    # Start the upload.
    results = transfer_manager.upload_many_from_filenames(
        bucket, string_paths, source_directory=source_directory, max_workers=workers
    )

    for name, result in zip(string_paths, results):
        # The results list is either `None` or an exception for each filename in
        # the input list, in order.

        if isinstance(result, Exception):
            print("Failed to upload {} due to exception: {}".format(name, result))
        else:
            print("Uploaded {} to {}.".format(name, bucket.name))



if __name__ == "__main__":

    upload_directory_with_transfer_manager(bucket_name,source_directory)
