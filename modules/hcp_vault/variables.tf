variable "vpc_id" {
  description = "Peer ID from the AWS peering VPC"
  type        = string
}

variable "vpc_owner_id" {
  description = "Peer account ID from AWS"
  type        = string
}

variable "vpc_cidr" {
  description = "Destination CIDR block of the AWS VPC"
  type        = string
}

variable "vpc_region" {
  description = "Region where the AWS VPC was created"
  type        = string
}

variable "hcp_cidr_block" {
  description = "CIDR block for the HVN VPC"
  type        = string
  default     = "172.25.16.0/20"
}

variable "hcp_tier" {
  description = "Tier to provision in HCP Vault - dev, standard_small, standard_medium, standard_large"
  type        = string
  default     = "dev"
  validation {
    condition     = var.hcp_tier != "dev" || var.hcp_tier != "standard_small" || var.hcp_tier != "standard_medium" || var.hcp_tier != "standard_large"
    error_message = "The variable hcp_tier must be \"dev\", \"standard_small\", \"standard_medium\", or \"standard_large\"."
  }
}

variable "hvn_route_id" {
  description = "The ID of the HCP HVN route."
  type        = string
  default     = "hcp-hvn-route"
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "us-west-2"
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
  default     = "aws"
}

variable "hcp_public_endpoint" {
  description = "Exposes the cluster to the internet. Defaults to false"
  type        = bool
  default     = false
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
  default     = "hcp-vault-hvn"
}

variable "hcp_cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
  default     = "hcp-vault-cluster"
}

variable "hvn_peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
  default     = "hcp-hvn-peering"
}