// creates a route for HVN to aws
resource "hcp_hvn_route" "hvn_peer_route" {
  hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.vpc_cidr
  target_link      = hcp_aws_network_peering.hvn_aws_peer.self_link
}

resource "hcp_aws_network_peering" "hvn_aws_peer" {
  hvn_id          = hcp_hvn.hcp_vault_hvn.hvn_id
  peering_id      = var.hvn_peering_id
  peer_vpc_id     = var.vpc_id
  peer_account_id = var.vpc_owner_id
  peer_vpc_region = var.vpc_region
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

// accept the peering request between hvn and aws
resource "aws_vpc_peering_connection_accepter" "hvn_aws_accept" {
  vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer.provider_peering_id
  auto_accept               = true
  tags = {
    Name = var.hvn_peering_id
  }
}
