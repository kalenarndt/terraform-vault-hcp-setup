<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>3.51.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~>0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.51.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.aws_hcp_jump_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.aws_vault_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.aws_hcp_jump_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.aws_vault_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.aws_vault_sg_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.aws_hcp_jump_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.aws_vpc_hvn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_peering_connection_accepter.hvn_aws_accept](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [hcp_aws_network_peering.hvn_aws_peer](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/aws_network_peering) | resource |
| [hcp_hvn.hcp_vault_hvn](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn) | resource |
| [hcp_hvn_route.hvn_peer_route](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn_route) | resource |
| [hcp_vault_cluster.vault_cluster](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/vault_cluster) | resource |
| [aws_arn.aws_vpc_peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cidr_block"></a> [aws\_cidr\_block](#input\_aws\_cidr\_block) | CIDR block for the AWS VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_aws_environment_tag"></a> [aws\_environment\_tag](#input\_aws\_environment\_tag) | Tag that will be applied to all AWS resources | `string` | `"HCP"` | no |
| <a name="input_aws_hcp_ec2_subnet"></a> [aws\_hcp\_ec2\_subnet](#input\_aws\_hcp\_ec2\_subnet) | CIDR block for EC2 workloads. Should be allocated from the VPC subnet range. | `string` | `"10.0.1.0/24"` | no |
| <a name="input_aws_hcp_jump_igw_name"></a> [aws\_hcp\_jump\_igw\_name](#input\_aws\_hcp\_jump\_igw\_name) | Name of the Internet Gateway that will be created and associated with the VPC. Specified as a tag | `string` | `"hcp-vault-jump-igw"` | no |
| <a name="input_aws_hcp_jump_subnet_name"></a> [aws\_hcp\_jump\_subnet\_name](#input\_aws\_hcp\_jump\_subnet\_name) | Name of the Subnet that will be created in the VPC. Specified as a tag | `string` | `"hcp-vault-subnet"` | no |
| <a name="input_aws_owner_tag"></a> [aws\_owner\_tag](#input\_aws\_owner\_tag) | Tag that will be appled to all AWS resources. | `string` | n/a | yes |
| <a name="input_aws_product_tag"></a> [aws\_product\_tag](#input\_aws\_product\_tag) | Tag that will be applied to all AWS resources | `string` | `"vault"` | no |
| <a name="input_aws_route_table_name"></a> [aws\_route\_table\_name](#input\_aws\_route\_table\_name) | Name of the AWS Route Table that will be created. Specified as a tag | `string` | `"hcp-vault-rt"` | no |
| <a name="input_aws_vault_sg_desc"></a> [aws\_vault\_sg\_desc](#input\_aws\_vault\_sg\_desc) | Description for the AWS Security Group that will be created to allow access to Vault | `string` | `"Security Group that allows access to HCP Vault"` | no |
| <a name="input_aws_vault_sg_name"></a> [aws\_vault\_sg\_name](#input\_aws\_vault\_sg\_name) | AWS Security Group name tag that will be set on the security group | `string` | `"hcp-vault-sg"` | no |
| <a name="input_aws_vault_sg_prefix"></a> [aws\_vault\_sg\_prefix](#input\_aws\_vault\_sg\_prefix) | AWS Security Group name prefix that will be set on the security group | `string` | `"hcp-vault-sg-"` | no |
| <a name="input_aws_vpc_hvn_name"></a> [aws\_vpc\_hvn\_name](#input\_aws\_vpc\_hvn\_name) | Name of the AWS VPC that will be created. Specified as a tag | `string` | `"hcp-vault-vpc"` | no |
| <a name="input_aws_vpc_peering_name"></a> [aws\_vpc\_peering\_name](#input\_aws\_vpc\_peering\_name) | Name of the Peering Connection that will be created. Specified as a tag | `string` | `"hcp-vault-pc"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider of the HCP HVN and Vault cluster. | `string` | `"aws"` | no |
| <a name="input_hcp_cidr_block"></a> [hcp\_cidr\_block](#input\_hcp\_cidr\_block) | CIDR block for the HVN VPC | `string` | `"172.25.16.0/20"` | no |
| <a name="input_hcp_client_id"></a> [hcp\_client\_id](#input\_hcp\_client\_id) | Client ID used to authenticate with HCP | `string` | `null` | no |
| <a name="input_hcp_client_secret"></a> [hcp\_client\_secret](#input\_hcp\_client\_secret) | Client secret used to authenticate with HCP | `string` | `null` | no |
| <a name="input_hcp_cluster_id"></a> [hcp\_cluster\_id](#input\_hcp\_cluster\_id) | The ID of the HCP Vault cluster. | `string` | `"hcp-vault-cluster"` | no |
| <a name="input_hcp_public_endpoint"></a> [hcp\_public\_endpoint](#input\_hcp\_public\_endpoint) | Exposes the cluster to the internet. Defaults to false | `bool` | `false` | no |
| <a name="input_hcp_tier"></a> [hcp\_tier](#input\_hcp\_tier) | Tier to provision in HCP Vault - dev, standard\_small, standard\_medium, standard\_large | `string` | `"dev"` | no |
| <a name="input_hvn_id"></a> [hvn\_id](#input\_hvn\_id) | The ID of the HCP HVN. | `string` | `"hcp-vault-hvn"` | no |
| <a name="input_hvn_peering_id"></a> [hvn\_peering\_id](#input\_hvn\_peering\_id) | The ID of the HCP peering connection. | `string` | `"hcp-hvn-peering"` | no |
| <a name="input_hvn_route_id"></a> [hvn\_route\_id](#input\_hvn\_route\_id) | The ID of the HCP HVN route. | `string` | `"hcp-hvn-route"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the HCP HVN and Vault cluster. | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_cluster_id"></a> [vault\_cluster\_id](#output\_vault\_cluster\_id) | n/a |
| <a name="output_vault_private_endpoint_url"></a> [vault\_private\_endpoint\_url](#output\_vault\_private\_endpoint\_url) | n/a |
| <a name="output_vault_tier"></a> [vault\_tier](#output\_vault\_tier) | n/a |
| <a name="output_vault_version"></a> [vault\_version](#output\_vault\_version) | n/a |
<!-- END_TF_DOCS -->