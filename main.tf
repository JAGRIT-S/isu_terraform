provider "google" {
  project = var.project_id
  region  = var.region
}

# Creating a GCS Bucket
resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.region
}

# Backend Configuration to store state file
terraform {
  backend "gcs" {
    bucket  = "isu_public_bucket"
    prefix  = "terraform/state"
  }
}