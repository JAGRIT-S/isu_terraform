provider "google" {
  project = var.project_id
  region  = var.region
}

# Creating a VPC
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

# Creating a VM
resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {}
  }
}

# Creating a GCS Bucket
resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.region
}

# Creating Firewall Rule
resource "google_compute_firewall" "allow_ssh" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Creating Log Sink
resource "google_logging_project_sink" "log_sink" {
  name        = var.log_sink_name
  destination = "storage.googleapis.com/${google_storage_bucket.bucket.name}"
}

# Backend Configuration to store state file
terraform {
  backend "gcs" {
    bucket  = var.state_bucket_name
    prefix  = "terraform/state"
  }
}