provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.aws_environment_tag
      Product     = var.aws_product_tag
      Owner       = var.aws_owner_tag
    }
  }
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}