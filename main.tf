// create the aws vpc
resource "aws_vpc" "aws_vpc_hvn" {
  cidr_block = var.aws_cidr_block
  tags = {
    Name = var.aws_vpc_hvn_name
  }
}

// reads the data from the aws vpc for HCP
data "aws_arn" "aws_vpc_peer" {
  arn = aws_vpc.aws_vpc_hvn.arn
}

// creates a route for HVN to aws
resource "hcp_hvn_route" "hvn_peer_route" {
  hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = aws_vpc.aws_vpc_hvn.cidr_block
  target_link      = hcp_aws_network_peering.hvn_aws_peer.self_link
}

// configures peering between hvn and aws
resource "hcp_aws_network_peering" "hvn_aws_peer" {
  hvn_id          = hcp_hvn.hcp_vault_hvn.hvn_id
  peering_id      = var.hvn_peering_id
  peer_vpc_id     = aws_vpc.aws_vpc_hvn.id
  peer_account_id = aws_vpc.aws_vpc_hvn.owner_id
  peer_vpc_region = data.aws_arn.aws_vpc_peer.region
}

// accept the peering request between hvn and aws
resource "aws_vpc_peering_connection_accepter" "hvn_aws_accept" {
  vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer.provider_peering_id
  auto_accept               = true
  tags = {
    Name = var.aws_vpc_peering_name
  }

}

// creates the hvn network resource
resource "hcp_hvn" "hcp_vault_hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.region
  cidr_block     = var.hcp_cidr_block
}

// creates the vault cluster on the hvn network resource
resource "hcp_vault_cluster" "vault_cluster" {
  hvn_id          = hcp_hvn.hcp_vault_hvn.hvn_id
  cluster_id      = var.hcp_cluster_id
  tier            = var.hcp_tier
  public_endpoint = var.hcp_public_endpoint
}


// creates a security group in aws for vault access
resource "aws_security_group" "aws_vault_sg" {
  description = var.aws_vault_sg_desc
  vpc_id      = aws_vpc.aws_vpc_hvn.id
  name_prefix = var.aws_vault_sg_prefix
  tags = {
    Name = var.aws_vault_sg_name
  }
}

// creates the security group rules in aws for vault access
resource "aws_security_group_rule" "aws_vault_sg_rules" {
  type              = "egress"
  from_port         = 8200
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = [hcp_hvn.hcp_vault_hvn.cidr_block]
  security_group_id = aws_security_group.aws_vault_sg.id
}

// creates the aws route table for the VPC 
resource "aws_route_table" "aws_vault_route_table" {
  vpc_id = aws_vpc.aws_vpc_hvn.id

  route {
    cidr_block                = hcp_hvn.hcp_vault_hvn.cidr_block
    vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer.provider_peering_id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_hcp_jump_igw.id
  }

  tags = {
    Name = var.aws_route_table_name
  }
}

// creates an aws subnet for ec2 workloads in aws
resource "aws_subnet" "aws_hcp_jump_subnet" {
  vpc_id     = aws_vpc.aws_vpc_hvn.id
  cidr_block = var.aws_hcp_ec2_subnet

  tags = {
    Name = var.aws_hcp_jump_subnet_name
  }
}

// associates the aws route table with the subnet to allow for access to HCP Vault and the internet
resource "aws_route_table_association" "aws_hcp_jump_subnet_association" {
  subnet_id      = aws_subnet.aws_hcp_jump_subnet.id
  route_table_id = aws_route_table.aws_vault_route_table.id
}

// creates an aws internet gateway and associates it with the vpc
resource "aws_internet_gateway" "aws_hcp_jump_igw" {
  vpc_id = aws_vpc.aws_vpc_hvn.id
  tags = {
    Name = var.aws_hcp_jump_igw_name
  }
}



