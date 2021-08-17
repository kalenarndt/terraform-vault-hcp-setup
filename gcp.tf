variable "gcp_region" {
  default = "us-central1"
}

variable "gcp_asn" {
  default = "64512"
}

variable "project" {
  default = "kalen-ahead-testing"
}

resource "google_compute_network" "main" {
  project                 = var.project
  name                    = "test-network"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  project       = var.project
  name          = "private-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.gcp_region
  network       = google_compute_network.main.self_link
}

resource "google_compute_vpn_gateway" "vpn_gw" {
  name    = "vpn-gw"
  network = google_compute_network.main.self_link
  region  = var.gcp_region
}

resource "google_compute_router" "cloud_router" {
  name    = "cloud-rtr"
  network = google_compute_network.main.self_link
  bgp {
    asn               = var.gcp_asn
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
  }
}

# resource "google_compute_address" "name" {

# }