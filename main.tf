resource "aws_grafana_workspace" "monitoring" {
  name                      = var.workspace_name
  account_access_type       = "CURRENT_ACCOUNT"
  authentication_providers  = var.grafana_auth_providers
  permission_type           = "CUSTOMER_MANAGED"
  role_arn                  = aws_iam_role.grafana_workspace.arn
  data_sources              = ["CLOUDWATCH", "XRAY"]
  notification_destinations = ["SNS"]

  configuration = jsonencode({
    unifiedAlerting = {
      enabled = true
    }
  })

  tags = local.tags
}
