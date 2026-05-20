locals {
  default_tags = {
    Project     = "grafana-monitoring"
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  tags = merge(local.default_tags, var.tags)
}
