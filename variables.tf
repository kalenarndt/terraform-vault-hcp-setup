variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
  default     = "hcp-vault-hvn"
}

variable "cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
  default     = "hcp-vault-cluster"
}

variable "peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
  default     = "hcp-hvn-peering"
}

variable "route_id" {
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

variable "public_endpoint" {
  description = "Exposes the cluster to the internet. Defaults to false"
  type = bool
  default = false
}

variable "hcp_client_id" {
  description = "Client ID used to authenticate with HCP"
  type = string
  sensitive = false
  default = null
}

variable "hcp_client_secret" {
  description = "Client secret used to authenticate with HCP"
  type = string
  sensitive = true
  default = null
}

variable "aws_cidr_block" {
  description = "CIDR block for the AWS VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "hcp_cidr_block" {
  description = "CIDR block for the HVN VPC"
  type = string
  default = "172.25.16.0/20"
}

variable "hcp_tier" {
  description = "Tier to provision in HCP Vault - dev, standard_small, standard_medium, standard_large"
  type = string
  default = "dev"
}

variable "aws_vault_sg" {
  description = "AWS Security Group that will be created to allow access to Vault"
  type = string
  default = "hcp-vault-sg"
}

variable "aws_vault_sg_desc" {
  description = "Description for the AWS Security Group that will be created to allow access to Vault"
  type = string
  default = "Security Group that allows access to HCP Vault"
}
