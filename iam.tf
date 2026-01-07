locals {
  env_name = "nik-is-cool"
  grafana_group_ids = [
    "06427284-d0b1-7081-157a-470f177da2c7"
  ]
}

module "managed_grafana" {
  version = "2.3.1"
  source  = "terraform-aws-modules/managed-service-grafana/aws"
  # source = "git@github.com:terraform-aws-modules/terraform-aws-managed-service-grafana.git?ref=6d82b7f0ee28dd51b7309682409f6fae29683ce5"
  # Workspace
  name                     = local.env_name
  associate_license        = false
  description              = "The Grafana workspace for the Dissemination PaaS for ${local.env_name}"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  # data_sources              = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
  data_sources = ["PROMETHEUS"]
  # notification_destinations = ["SNS"]
  configuration = jsonencode({
    unifiedAlerting = {
      enabled = true
    },
    plugins = {
      pluginAdminEnabled = true
    }
  })

  grafana_version = "10.4"

  role_associations = {
    "ADMIN" = {
      "group_ids" = local.grafana_group_ids
    }
  }
}