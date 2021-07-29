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

variable "hcp_client_id" {
  description = "Client ID used to authenticate with HCP"
  type        = string
  sensitive   = false
  default     = null
}

variable "hcp_client_secret" {
  description = "Client secret used to authenticate with HCP"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_cidr_block" {
  description = "CIDR block for the AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
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
}

variable "aws_vault_sg_prefix" {
  description = "AWS Security Group name prefix that will be set on the security group"
  type        = string
  default     = "hcp-vault-sg-"
}

variable "aws_vault_sg_name" {
  description = "AWS Security Group name tag that will be set on the security group"
  type        = string
  default     = "hcp-vault-sg"
}

variable "aws_vault_sg_desc" {
  description = "Description for the AWS Security Group that will be created to allow access to Vault"
  type        = string
  default     = "Security Group that allows access to HCP Vault"
}

variable "aws_vpc_hvn_name" {
  description = "Name of the AWS VPC that will be created. Specified as a tag"
  type        = string
  default     = "hcp-vault-vpc"
}

variable "aws_vpc_peering_name" {
  description = "Name of the Peering Connection that will be created. Specified as a tag"
  type        = string
  default     = "hcp-vault-pc"
}

variable "aws_route_table_name" {
  description = "Name of the AWS Route Table that will be created. Specified as a tag"
  type        = string
  default     = "hcp-vault-rt"
}

variable "aws_hcp_ec2_subnet" {
  description = "CIDR block for EC2 workloads. Should be allocated from the VPC subnet range."
  type        = string
  default     = "10.0.1.0/24"
}

variable "aws_hcp_jump_subnet_name" {
  description = "Name of the Subnet that will be created in the VPC. Specified as a tag"
  type        = string
  default     = "hcp-vault-subnet"
}

variable "aws_hcp_jump_igw_name" {
  description = "Name of the Internet Gateway that will be created and associated with the VPC. Specified as a tag"
  type        = string
  default     = "hcp-vault-jump-igw"
}

variable "aws_owner_tag" {
  description = "Tag that will be appled to all AWS resources."
  type        = string
}

variable "aws_product_tag" {
  description = "Tag that will be applied to all AWS resources"
  type        = string
  default     = "vault"
}

variable "aws_environment_tag" {
  description = "Tag that will be applied to all AWS resources"
  type        = string
  default     = "HCP"
}