module "irsa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=2.0.0"

  # EKS configuration
  eks_cluster_name = var.eks_cluster_name

  # IRSA configuration
  service_account_name = "rndserviceaccount"
  namespace            = var.namespace # this is also used as a tag

  # Attach the appropriate policies using a key => value map
  # If you're using Cloud Platform provided modules (e.g. SNS, S3), these
  # provide an output called `irsa_policy_arn` that can be used.
  role_policy_arns = {
    # for the local S3 bucket
    s3_local = module.s3_bucket.irsa_policy_arn

    # for the Analytical Platform S3 bucket
    s3 = aws_iam_policy.mojap-rd_access_policy.arn

    # for the local dynamodb
    dynamodb = module.dynamodb.irsa_policy_arn
  }

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}

resource "kubernetes_secret" "irsa" {
  metadata {
    name      = "irsa-output"
    namespace = var.namespace
  }

  data = {
    role           = module.irsa.role_name
    rolearn        = module.irsa.role_arn
    serviceaccount = module.irsa.service_account.name
  }
}

