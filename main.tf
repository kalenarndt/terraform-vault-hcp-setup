# data "aws_availability_zones" "aws_az_list" {
#   state = "available"
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }

# module "aws_vpc" {
#   source               = "terraform-aws-modules/vpc/aws"
#   version              = "3.2.0"
#   name                 = var.aws_vpc_hvn_name
#   cidr                 = var.aws_vpc_cidr_block
#   azs                  = data.aws_availability_zones.aws_az_list.names
#   private_subnets      = [var.aws_hcp_bastion_subnet]
#   enable_dns_hostnames = true
# }

################################################### Quick and dirty transit gateway for testing

resource "aws_vpc" "example" {
  cidr_block = var.aws_vpc_cidr_block
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.aws_hcp_bastion_subnet
  availability_zone = var.az
}

resource "aws_ec2_transit_gateway" "example" {
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.my_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.example.id
}

resource "aws_ram_resource_share" "example" {
  name                      = "example-resource-share"
  allow_external_principals = true
}

resource "aws_ram_resource_association" "example" {
  resource_share_arn = aws_ram_resource_share.example.arn
  resource_arn       = aws_ec2_transit_gateway.example.arn
}

resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.example.id
}

resource "aws_main_route_table_association" "main-vpc" {
  vpc_id         = aws_vpc.example.id
  route_table_id = aws_route_table.main-rt.id
}

resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block         = var.hvn_vault_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.example.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }

  # depends_on = [ 
  #     aws_ec2_transit_gateway_vpc_attachment.example,
  # ]
}

resource "aws_security_group" "main-vpc-sg" {
  name   = "kalen-hcp-testing-sg"
  vpc_id = aws_vpc.example.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "test-tgw-keypair" {
  key_name   = "kalen-test-keypair"
  public_key = tls_private_key.ssh-key.public_key_openssh
}

resource "aws_instance" "test-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.my_subnet.id
  vpc_security_group_ids      = [aws_security_group.main-vpc-sg.id]
  key_name                    = aws_key_pair.test-tgw-keypair.key_name
  associate_public_ip_address = true
  user_data                   = data.template_file.init.rendered
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# export ssh key
resource "local_file" "private_key" {
  content         = tls_private_key.ssh-key.private_key_pem
  filename        = "private_key.pem"
  file_permission = "0600"
}

data "template_file" "init" {
  template = file("${path.module}/init.tpl")
}

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