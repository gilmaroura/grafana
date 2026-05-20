# Configuração do Backend
# Por padrão, o estado é armazenado localmente para simplificar o desenvolvimento.
# Para produção, descomente o bloco abaixo e configure o bucket S3 e a tabela DynamoDB.

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  # backend "s3" {
  #   bucket         = "NOME-DO-SEU-BUCKET-TFSTATE"
  #   key            = "grafana/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-lock"
  # }
}
