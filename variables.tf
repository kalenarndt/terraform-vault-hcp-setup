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

## ====================

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "us-west-2"
}

variable "aws_vpc_cidr_block" {
  description = "CIDR block for the AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
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

variable "aws_hcp_bastion_subnet" {
  description = "CIDR block for EC2 workloads. Should be allocated from the VPC subnet range."
  type        = string
  default     = "10.0.1.0/24"
}

variable "aws_hcp_bastion_subnet_name" {
  description = "Name of the Subnet that will be created in the VPC. Specified as a tag"
  type        = string
  default     = "hcp-vault-bastion-subnet"
}

variable "aws_hcp_bastion_igw_name" {
  description = "Name of the Internet Gateway that will be created and associated with the VPC. Specified as a tag"
  type        = string
  default     = "hcp-vault-bastion-igw"
}

variable "aws_hcp_bastion_ec2_name" {
  description = "Tag that will be appled to the EC2 bastion host. Specified as a tag"
  type        = string
  default     = "hcp-vault-bastion-ec2"
}

variable "vpc_peering" {
  description = "Flag to enable vpc peering with HCP and AWS"
  type        = bool
  default     = true
}

variable "aws_tag_name" {
  description = "Your name - This will be added to all the AWS resources that will be provisioned as a tag"
  type        = string
  default     = ""
}

variable "aws_tag_ttl" {
  description = "TTL of the resources that will be provisioned for this demo. Specified in hours."
  type        = number
  default     = 24
}

variable "aws_tag_environment" {
  description = "Tag that will be applied to all AWS resources"
  type        = string
  default     = "HCP"
}

variable "aws_tag_owner" {
  description = "Your email - This tag that will be appled to all AWS resources."
  type        = string
}

################################ TRANSIT GATEWAY TESTING

variable "tgw_name" {
  default = "hcp-tgw"
}

variable "hvn_vault_cidr_block" {
  description = "CIDR block for the HVN Vault VPC"
  type        = string
  default     = "172.25.16.0/24"
}

variable "az" {
  default = "us-west-2a"
}
