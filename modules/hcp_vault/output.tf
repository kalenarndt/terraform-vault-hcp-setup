output "vault_private_endpoint_url" {
  value = hcp_vault_cluster.vault_cluster[0].vault_private_endpoint_url
}

output "vault_public_endpoint_url" {
  value = hcp_vault_cluster.vault_cluster[0].vault_public_endpoint_url
}

output "vault_cluster_id" {
  value = hcp_vault_cluster.vault_cluster[0].cluster_id
}

output "vault_tier" {
  value = hcp_vault_cluster.vault_cluster[0].tier
}

output "vault_version" {
  value = hcp_vault_cluster.vault_cluster[0].vault_version
}

