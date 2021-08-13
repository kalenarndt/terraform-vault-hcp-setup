variable "vpc_id" {
  description = "Peer ID from the AWS peering VPC"
  type        = string
  default     = ""
}

variable "vpc_owner_id" {
  description = "Peer account ID from AWS"
  type        = string
  default     = ""
}

variable "vpc_peering" {
  description = "Flag to enable vpc peering with HCP and AWS"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "Destination CIDR block of the AWS VPC"
  type        = string
  default     = ""
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

variable "hcp_vault_tier" {
  description = "Tier to provision in HCP Vault - dev, standard_small, standard_medium, standard_large"
  type        = string
  default     = "dev"
  validation {
    condition     = var.hcp_vault_tier != "dev" || var.hcp_vault_tier != "standard_small" || var.hcp_vault_tier != "standard_medium" || var.hcp_vault_tier != "standard_large"
    error_message = "The variable hcp_vault_tier must be \"dev\", \"standard_small\", \"standard_medium\", or \"standard_large\"."
  }
}

variable "create_vault_cluster" {
  description = "Flag to create a vault cluster"
  type        = bool
  default     = true
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

variable "min_vault_version" {
  description = "Minimum Vault version to use when creating cluster. If null, defaults to HCP recommended version"
  type        = string
  default     = null
}

variable "transit_gw_attachment_id" {
  description = "Name of the transit gateway attachment in HVN"
  type        = string
  default     = "hcp-hvn-transit-gw"
}

variable "transit_gw" {
  description = "Flag to use an aws transit gateway"
  type        = bool
  default     = false
}

variable "transit_gw_id" {
  description = "ID of the transit gateway that exists in AWS that HCP will attach to"
  type        = string
  default     = ""
}

variable "resource_share_arn" {
  description = "Amazon Resource Name of the Resource Share that is needed to grant HCP acces to the transit gateway"
  type        = string
  default     = ""
}


