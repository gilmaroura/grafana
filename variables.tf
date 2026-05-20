variable "aws_region" {
  description = "AWS region for the Amazon Managed Grafana workspace."
  type        = string
  default     = "us-east-1"
}

variable "workspace_name" {
  description = "Name of the Amazon Managed Grafana workspace."
  type        = string
  default     = "GRAFANA_Triskin"
}

variable "environment" {
  description = "Environment label used in resource tags."
  type        = string
  default     = "prod"
}

variable "create_admin_access_key" {
  description = "Create an access key for the Admin_grafana IAM user. Keep false unless required."
  type        = bool
  default     = false
}

variable "grafana_auth_providers" {
  description = "Authentication providers for the Grafana workspace (AWS_SSO or SAML)."
  type        = list(string)
  default     = ["AWS_SSO"]

  validation {
    condition = alltrue([
      for p in var.grafana_auth_providers : contains(["AWS_SSO", "SAML"], p)
    ])
    error_message = "grafana_auth_providers must only contain AWS_SSO and/or SAML."
  }
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "admin_email" {
  description = "Email address for the Grafana Admin user in IAM Identity Center."
  type        = string
  default     = "admin.projects@triskin.tech"
}
