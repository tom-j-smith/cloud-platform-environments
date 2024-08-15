module "secrets_manager" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-secrets-manager?ref=3.0.4"
  team_name              = var.team_name
  application            = var.application
  business_unit          = var.business_unit
  is_production          = var.is_production
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  eks_cluster_name       = var.eks_cluster_name

  secrets = {
    "maat_api_oauth_client_id" = {
      description             = "MAAT API oauth client ID for DRC Integration Stg",
      recovery_window_in_days = 7
      k8s_secret_name         = "maat-api-oauth-client-id"
    },
    "maat_api_oauth_client_secret" = {
      description             = "MAAT API oauth client secret for DRC Integration Stg",
      recovery_window_in_days = 7
      k8s_secret_name         = "maat-api-oauth-client-secret"
    },
    "key-store-password" = {
      description             = "mTLS key store password for DRC Integration Stg",
      recovery_window_in_days = 7
      k8s_secret_name         = "key-store-password"
    },
    "trust-store-password" = {
      description             = "mTLS Trust store password for DRC Integration Stg",
      recovery_window_in_days = 7
      k8s_secret_name         = "trust-store-password"
    },  }
}