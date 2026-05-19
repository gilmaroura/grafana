provider "aws" {
  region = "us-east-1"
}

resource "aws_grafana_workspace" "grafana" {
  name                     = "grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"

  data_sources = [
    "AMAZON_OPENSEARCH_SERVICE",
    "CLOUDWATCH",
    "PROMETHEUS"
  ]
}

resource "aws_iam_user" "admin_grafana" {
  name = "admin_grafana"
}

resource "aws_iam_user_policy" "grafana_admin_policy" {
  name = "GrafanaAdminPolicy"
  user = aws_iam_user.admin_grafana.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "grafana:DescribeWorkspace",
          "grafana:ListWorkspaces"
        ]
        Resource = aws_grafana_workspace.grafana.arn
      }
    ]
  })
}

resource "aws_grafana_role_association" "admin" {
  workspace_id = aws_grafana_workspace.grafana.id
  role         = "ADMIN"

  user_ids = [
    aws_iam_user.admin_grafana.arn
  ]
}

output "grafana_endpoint" {
  value = aws_grafana_workspace.grafana.endpoint
}

output "iam_user_arn" {
  value = aws_iam_user.admin_grafana.arn
}