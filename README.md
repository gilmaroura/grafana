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

## Segurança e Identidade

Este projeto cria um usuário IAM (`Admin_grafana`) para fins administrativos, mas a AWS recomenda o uso do **AWS IAM Identity Center (SSO)** como provedor de autenticação principal para o Amazon Managed Grafana.

Se você estiver usando `AWS_SSO` (padrão em `variables.tf`), certifique-se de que o Identity Center esteja configurado na mesma região.

## Pós-Implantação

Após rodar o `terraform apply`, o workspace estará criado, mas você ainda precisará:

1.  **Atribuir Acesso:** No console da AWS (Amazon Managed Grafana), vá em "Workspaces", selecione o seu workspace e atribua usuários ou grupos do IAM Identity Center com o papel de `ADMIN` ou `EDITOR`.
2.  **Configurar Data Sources:** Acesse a URL do Grafana (fornecida no output `grafana_workspace_endpoint`) e configure o CloudWatch/X-Ray. O Terraform já preparou a Role IAM com as permissões necessárias.

## Estrutura

| Arquivo | Descrição |
|---------|-----------|
| `main.tf` | Workspace Grafana |
| `iam_workspace_role.tf` | Role e políticas do workspace (datasources) |
| `iam_admin_grafana.tf` | Usuário IAM `Admin_grafana` |
| `variables.tf` | Variáveis de entrada |
| `locals.tf` | Lógica de tags e variáveis locais |
| `outputs.tf` | Endpoint, ARN do workspace, etc. |
| `backend.tf` | Backend local do state (apenas desenvolvimento) |

## O que não vai para o Git

- Pasta `.terraform/` e providers baixados
- Arquivos `*.tfstate`
- `terraform.tfvars` com valores locais/sensíveis
