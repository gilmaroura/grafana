provider "aws" {
  region = "us-east-1" # Altere para sua região de preferência
}

# Workspace do Grafana
resource "aws_grafana_workspace" "grafana" {
  name                     = "grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"] # Define AWS IAM Identity Center como provedor
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "PROMETHEUS"]
}

# Usuário IAM
resource "aws_iam_user" "admin_grafana" {
  name = "admin_grafana"
}

# Chaves de acesso para o usuário (opcional, para uso via CLI/API)
resource "aws_iam_access_key" "admin_grafana_key" {
  user = aws_iam_user.admin_grafana.name
}

# Política de Administrador do Grafana para o Usuário IAM
# Esta política permite que o usuário gerencie o workspace via AWS (API/CLI)
resource "aws_iam_user_policy" "grafana_admin_policy" {
  name = "GrafanaAdminPolicy"
  user = aws_iam_user.admin_grafana.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "grafana:*",
          "sso:DescribeInstance",
          "sso:ListInstances",
          "sso:AssociateDirectory",
          "sso:ListDirectoryAssociations"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "grafana_endpoint" {
  value = aws_grafana_workspace.grafana.endpoint
}

output "iam_user_arn" {
  value = aws_iam_user.admin_grafana.arn
}
