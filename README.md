# Amazon Managed Grafana (Terraform)

Infraestrutura como código para um workspace **Amazon Managed Grafana** com IAM para monitoramento (CloudWatch, X-Ray) e usuário administrativo.

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- AWS CLI configurado (`aws configure` ou variáveis de ambiente)
- Permissões IAM para criar workspace Grafana, roles e usuários

## Uso

```bash
terraform init
terraform plan
terraform apply
```

Opcional: copie `terraform.tfvars.example` para `terraform.tfvars` e ajuste os valores (esse arquivo não é versionado).

## Estrutura

| Arquivo | Descrição |
|---------|-----------|
| `main.tf` | Workspace Grafana |
| `iam_workspace_role.tf` | Role e políticas do workspace (datasources) |
| `iam_admin_grafana.tf` | Usuário IAM `Admin_grafana` |
| `variables.tf` | Variáveis e tags |
| `outputs.tf` | Endpoint, ARN do workspace, etc. |
| `backend.tf` | Backend local do state (apenas desenvolvimento) |

## O que não vai para o Git

- Pasta `.terraform/` e providers baixados
- Arquivos `*.tfstate`
- `terraform.tfvars` com valores locais/sensíveis
