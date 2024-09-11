variable "project_id" {
  description = "GCP Project ID"
}

variable "region" {
  description = "Region for resources"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "vm_name" {
  description = "Name of the VM instance"
}

variable "machine_type" {
  description = "Type of the VM machine"
}

variable "zone" {
  description = "Zone for the VM instance"
}

variable "boot_image" {
  description = "Boot image for the VM"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
}

variable "firewall_name" {
  description = "Name of the firewall rule"
}

variable "log_sink_name" {
  description = "Name of the log sink"
}

variable "state_bucket_name" {
  description = "GCS bucket name for storing Terraform state"
}