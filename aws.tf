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

# resource "aws_customer_gateway" "cust_gw" {
#   bgp_asn = 64512
#   ip_address = "172.0.0.1"
#   type = "ipsec.1"
# }

# resource "aws_vpn_connection" "gcp" {
#   customer_gateway_id = aws_customer_gateway.cust_gw.id
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#   tunnel1_inside_cidr =  = #GCP SUBNETS
#   remote_ipv4_network_cidr = #AWS SUBNETS + VAULT
# }