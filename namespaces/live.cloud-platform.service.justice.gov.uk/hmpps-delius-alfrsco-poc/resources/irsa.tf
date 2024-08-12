module "irsa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=2.0.0"

  # EKS configuration
  eks_cluster_name = var.eks_cluster_name

  # IRSA configuration
  service_account_name = "${var.team_name}-${var.environment}"
  role_policy_arns = {
    s3                             = module.s3_bucket.irsa_policy_arn
    rds                            = module.rds_alfresco.irsa_policy_arn
    s3_backups_bucket              = module.s3_backups_bucket.irsa_policy_arn
    s3_logging_bucket              = module.s3_logging_bucket.irsa_policy_arn
    s3_opensearch_snapshots_bucket = module.s3_opensearch_snapshots_bucket.irsa_policy_arn
  }

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace # this is also used to attach your service account to your namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}
