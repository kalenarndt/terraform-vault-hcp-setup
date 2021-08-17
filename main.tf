
output "aws_ip" {
  value = aws_instance.test-instance.public_ip
}

###############################################################################################

module "hcp_vault" {
  source               = "./modules/hcp_vault"
  vault_tier           = "dev"
  consul_tier          = "development"
  consul_size          = "x_small"
  vpc_region           = var.region
  vpc_id               = aws_vpc.example.id
  vpc_owner_id         = null
  vpc_cidr             = aws_vpc.example.cidr_block
  vpc_peering          = false
  transit_gw           = true
  resource_share_arn   = aws_ram_resource_share.example.arn
  transit_gw_id        = aws_ec2_transit_gateway.example.id
  create_vault_cluster = true
  # create_consul_cluster = true
  # generate_consul_token = true
  # generate_vault_token  = true
  # output_consul_token   = true
  # output_vault_token    = true
  # single_hvn            = false
}

# vpc_owner_id          = module.aws_vpc.vpc_owner_id

# module "hcp_vault_tokens" {
#   source                = "./modules/hcp_vault"
#   generate_consul_token = true
#   generate_vault_token  = true
#   output_consul_token   = true
#   output_vault_token    = true
# }


# // creates a security group in aws for vault access
# resource "aws_security_group" "aws_vault_sg" {
#   description = var.aws_vault_sg_desc
#   vpc_id      = aws_vpc.aws_vpc_hvn.id
#   name_prefix = var.aws_vault_sg_prefix
#   tags = {
#     Name = var.aws_vault_sg_name
#   }
# }

# // creates the security group rules in aws for vault access
# resource "aws_security_group_rule" "aws_vault_sg_rules" {
#   type              = "egress"
#   from_port         = 8200
#   to_port           = 8200
#   protocol          = "tcp"
#   cidr_blocks       = [hcp_hvn.hcp_vault_hvn.cidr_block]
#   security_group_id = aws_security_group.aws_vault_sg.id
# }

# // creates the aws route table for the VPC 
# resource "aws_route_table" "aws_vault_route_table" {
#   vpc_id = aws_vpc.aws_vpc_hvn.id

#   route {
#     cidr_block                = hcp_hvn.hcp_vault_hvn.cidr_block
#     vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer.provider_peering_id
#   }

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.aws_hcp_bastion_igw.id
#   }

#   tags = {
#     Name = var.aws_route_table_name
#   }
# }

# // creates an aws subnet for ec2 workloads in aws
# resource "aws_subnet" "aws_hcp_bastion_subnet" {
#   vpc_id     = aws_vpc.aws_vpc_hvn.id
#   cidr_block = var.aws_hcp_ec2_subnet

#   tags = {
#     Name = var.aws_hcp_bastion_subnet_name
#   }
# }

# // associates the aws route table with the subnet to allow for access to HCP Vault and the internet
# resource "aws_route_table_association" "aws_hcp_bastion_subnet_association" {
#   subnet_id      = aws_subnet.aws_hcp_bastion_subnet.id
#   route_table_id = aws_route_table.aws_vault_route_table.id
# }

# // creates an aws internet gateway and associates it with the vpc
# resource "aws_internet_gateway" "aws_hcp_bastion_igw" {
#   vpc_id = aws_vpc.aws_vpc_hvn.id
#   tags = {
#     Name = var.aws_hcp_bastion_igw_name
#   }
# }


# data "aws_ami" "aws_hcp_bastion_ami" {
#   most_recent = true
#   owners = ["amazon"]

#   filter {
#     name = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

# resource "aws_instance" "aws_hcp_bastion_ec2" {
#   ami = data.aws_ami.aws_hcp_bastion_ami.id
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.aws_hcp_bastion_subnet.id
#   associate_public_ip_address = true
#   vpc_security_group_ids = [ aws_security_group.aws_vault_sg.id ]
#   tags = {
#     Name = var.aws_hcp_bastion_ec2_name
#   }
# }