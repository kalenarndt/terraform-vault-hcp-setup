// create the aws vpc
resource "aws_vpc" "aws_vpc_hvn" {
  cidr_block = var.aws_cidr_block
}

// reads the data from the aws vpc for HCP
data "aws_arn" "aws_vpc_peer" {
  arn = aws_vpc.aws_vpc_hvn.arn
}

// creates a route for HVN to aws
resource "hcp_hvn_route" "hvn_peer_route" {
  hvn_link = hcp_hvn.hcp_vault_hvn.self_link
  hvn_route_id = var.route_id
  destination_cidr = aws_vpc.aws_vpc_hvn.cidr_block
  target_link = hcp_aws_network_peering.hvn_aws_peer.self_link
}

// configures peering between hvn and aws
resource "hcp_aws_network_peering" "hvn_aws_peer" {
  hvn_id = hcp_hvn.hcp_vault_hvn.hvn_id
  peering_id = var.peering_id
  peer_vpc_id = aws_vpc.aws_vpc_hvn.id
  peer_account_id = aws_vpc.aws_vpc_hvn.owner_id
  peer_vpc_region = data.aws_arn.aws_vpc_peer.region
}

// accept the peering request between hvn and aws
resource "aws_vpc_peering_connection_accepter" "hvn_aws_accept" {
  vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer.provider_peering_id
  auto_accept = true
}

// creates the hvn network resource
resource "hcp_hvn" "hcp_vault_hvn" {
  hvn_id = var.hvn_id
  cloud_provider = var.cloud_provider
  region = var.region
  cidr_block = var.hcp_cidr_block
}

// creates the vault cluster on the hvn network resource
resource "hcp_vault_cluster" "vault_cluster" {
  hvn_id = hcp_hvn.hcp_vault_hvn.hvn_id
  cluster_id = var.cluster_id
  tier = var.hcp_tier
  public_endpoint = var.public_endpoint
}


// creates a security group in aws for vault access
resource "aws_security_group" "aws_vault_sg" {
  name = var.aws_vault_sg
  description = var.aws_vault_sg_desc
  egress {
    cidr_blocks = [ var.hcp_cidr_block]
    description = var.aws_vault_sg_desc
    from_port = 0
    # ipv6_cidr_blocks = [ "value" ]
    # prefix_list_ids = [ "value" ]
    protocol = "tcp"
    # security_groups = [ "value" ]
    self = false
    to_port = 8200
  }
  tags = {
    "Name" = var.aws_vault_sg
  }

}

  #   cidr_blocks = [var.hcp_cidr_block]
  #   description = var.aws_vault_sg_desc
  #   from_port = 0
  #   protocol = "tcp"
  #   to_port = 8200
  # }

  # tags = {
  #   "Name" = var.aws_vault_sg
  # }