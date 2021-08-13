// creates a route for HVN to aws via the vpc
resource "hcp_hvn_route" "hvn_vpc_route" {
  count            = var.vpc_peering ? 1 : 0
  hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.vpc_cidr
  target_link      = hcp_aws_network_peering.hvn_aws_peer[0].self_link
}

// creates a peering request with aws
resource "hcp_aws_network_peering" "hvn_aws_peer" {
  count           = var.vpc_peering ? 1 : 0
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
  count             = var.create_vault_cluster ? 1 : 0
  hvn_id            = hcp_hvn.hcp_vault_hvn.hvn_id
  cluster_id        = var.hcp_cluster_id
  tier              = var.hcp_vault_tier
  public_endpoint   = var.hcp_public_endpoint
  min_vault_version = var.min_vault_version
}

// accept the peering request between hvn and aws
resource "aws_vpc_peering_connection_accepter" "hvn_aws_vpc_accept" {
  count                     = var.vpc_peering ? 1 : 0
  vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer[0].provider_peering_id
  auto_accept               = true
  tags = {
    Name = var.hvn_peering_id
  }
}

// creates an attachment to the aws transit gateway from hvn
resource "hcp_aws_transit_gateway_attachment" "hvn_transit_gw" {
  count                         = var.transit_gw ? 1 : 0
  hvn_id                        = hcp_hvn.hcp_vault_hvn.hvn_id
  transit_gateway_attachment_id = var.transit_gw_attachment_id
  transit_gateway_id            = var.transit_gw_id
  resource_share_arn            = var.resource_share_arn
}

// accept the hvn attachment to the transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "hvn_aws_tgw_accept" {
  count                         = var.transit_gw ? 1 : 0
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.hvn_transit_gw[0].provider_transit_gateway_attachment_id
}

// associates the hcp provider id with the resource_share arn in aws
resource "aws_ram_principal_association" "hcp_aws_ram" {
  count              = var.transit_gw ? 1 : 0
  resource_share_arn = var.resource_share_arn
  principal          = hcp_hvn.hcp_vault_hvn.provider_account_id
}

// creates a route from hvn to aws via the transit gateway
resource "hcp_hvn_route" "hvn_tgw_route" {
  count            = var.transit_gw ? 1 : 0
  hvn_link         = hcp_hvn.hcp_vault_hvn.self_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.vpc_cidr
  target_link      = hcp_aws_transit_gateway_attachment.hvn_transit_gw[0].self_link
}

