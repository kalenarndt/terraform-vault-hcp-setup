output "vault_private_endpoint_url" {
  value = hcp_vault_cluster.vault_cluster.vault_private_endpoint_url
}

output "vault_cluster_id" {
  value = hcp_vault_cluster.vault_cluster.cluster_id
}

output "vault_tier" {
  value = hcp_vault_cluster.vault_cluster.tier
}

output "vault_version" {
  value = hcp_vault_cluster.vault_cluster.vault_version
}



