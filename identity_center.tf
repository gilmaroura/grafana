# Busca as informações da instância do Identity Center (SSO) configurada na conta
data "aws_ssoadmin_instances" "this" {}

# Cria um usuário no Identity Store
resource "aws_identitystore_user" "grafana_admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = "Grafana Admin User"
  user_name    = "grafana_admin"

  name {
    given_name  = "Grafana"
    family_name = "Admin"
  }

  emails {
    value   = var.admin_email
    primary = true
  }
}

# Aumentando para 5 minutos (300s) para garantir a propagação na AWS.
# Em algumas contas/regiões, o registro da App SSO no Grafana pode ser lento.
resource "time_sleep" "wait_sso_registration" {
  depends_on = [
    aws_grafana_workspace.monitoring,
    aws_identitystore_user.grafana_admin
  ]
  create_duration = "300s"
}

# Associa o usuário ao Workspace do Grafana com o papel de ADMIN
resource "aws_grafana_role_association" "admin" {
  role         = "ADMIN"
  user_ids     = [aws_identitystore_user.grafana_admin.user_id]
  workspace_id = aws_grafana_workspace.monitoring.id

  # Garante que a associação só ocorra após o tempo de espera
  depends_on = [time_sleep.wait_sso_registration]
}
