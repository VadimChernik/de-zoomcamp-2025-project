terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.19.0"
    }
  }
}

provider "google" {
# Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  credentials = "key/de-zoomcamp-2025-gcp.json"
  project = "folkloric-stone-449913-n7"
  region  = "us-central1"
}

resource "google_storage_bucket" "data-lake-bucket" {
  name          = "bikeshare-bucket-449913-n7"
  location      = "US"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "bikeshare_dataset"
  project    = "folkloric-stone-449913-n7"
  location   = "US"
}

resource "google_compute_instance" "vm" {
  name         = "de-zoomcamp-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size = "30"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
}