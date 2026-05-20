output "grafana_workspace_id" {
  description = "Amazon Managed Grafana workspace ID."
  value       = aws_grafana_workspace.monitoring.id
}

output "grafana_workspace_endpoint" {
  description = "URL of the Amazon Managed Grafana workspace."
  value       = aws_grafana_workspace.monitoring.endpoint
}

output "grafana_workspace_arn" {
  description = "ARN of the Amazon Managed Grafana workspace."
  value       = aws_grafana_workspace.monitoring.arn
}

output "grafana_workspace_role_arn" {
  description = "IAM role ARN assumed by the Grafana workspace for data source access."
  value       = aws_iam_role.grafana_workspace.arn
}

output "admin_grafana_user_arn" {
  description = "ARN of the Admin_grafana IAM user."
  value       = aws_iam_user.admin_grafana.arn
}

output "admin_grafana_user_name" {
  description = "Name of the Admin_grafana IAM user."
  value       = aws_iam_user.admin_grafana.name
}

output "admin_grafana_access_key_id" {
  description = "Access key ID for Admin_grafana (only when create_admin_access_key is true)."
  value       = try(aws_iam_access_key.admin_grafana[0].id, null)
  sensitive   = true
}

output "admin_grafana_secret_access_key" {
  description = "Secret access key for Admin_grafana (only when create_admin_access_key is true)."
  value       = try(aws_iam_access_key.admin_grafana[0].secret, null)
  sensitive   = true
}

output "identity_store_user_id" {
  description = "The ID of the user created in IAM Identity Center."
  value       = aws_identitystore_user.grafana_admin.user_id
}

output "identity_store_user_name" {
  description = "The username of the user created in IAM Identity Center."
  value       = aws_identitystore_user.grafana_admin.user_name
}
