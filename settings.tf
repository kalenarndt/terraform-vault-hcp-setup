provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.aws_tag_environment
      Owner       = var.aws_tag_owner
      Name        = var.aws_tag_name
      TTL         = var.aws_tag_ttl
    }
  }
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}