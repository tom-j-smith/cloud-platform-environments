module "s3_bucket" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-s3-bucket?ref=5.1.0"
  team_name              = var.team_name
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace
  versioning             = var.versioning
  logging_enabled        = true
  log_target_bucket      = module.s3_logging_bucket.bucket_name
  log_path               = var.log_path

  lifecycle_rule = [
    {
      enabled = true

      noncurrent_version_transition = [
        {
          days          = var.s3_lifecycle_config["noncurrent_version_transition_days"]
          storage_class = "STANDARD_IA"
        },
        {
          days          = var.s3_lifecycle_config["noncurrent_version_transition_glacier_days"]
          storage_class = "GLACIER"
        },
      ]

      noncurrent_version_expiration = [
        {
          days = var.s3_lifecycle_config["noncurrent_version_expiration_days"]
        },
      ]
    }
  ]
}

resource "aws_iam_user" "alfresco_user" {
  name = "${var.namespace}-alfresco_user"
  path = "/system/${var.namespace}-alfresco_user/"
}

resource "aws_iam_access_key" "alfresco_user_access" {
  user = aws_iam_user.alfresco_user.name
}

resource "aws_iam_user_policy_attachment" "alfresco_user_policy" {
  policy_arn = module.s3_bucket.irsa_policy_arn
  user       = aws_iam_user.alfresco_user.name
}

data "aws_s3_bucket" "s3_alf_bucket" {
  bucket = module.s3_bucket.bucket_name
}

resource "aws_s3_bucket_accelerate_configuration" "aws_s3_bucket_accelerate_config" {
  bucket = data.aws_s3_bucket.s3_alf_bucket.id
  status = "Enabled"
}

resource "kubernetes_secret" "s3_bucket" {
  metadata {
    name      = "s3-bucket-output"
    namespace = var.namespace
  }

  data = {
    BUCKET_ARN  = module.s3_bucket.bucket_arn
    BUCKET_NAME = module.s3_bucket.bucket_name
    ACCESSKEY   = aws_iam_access_key.alfresco_user_access.id
    SECRETKEY   = aws_iam_access_key.alfresco_user_access.secret
  }
}

# This places a secret for this PoC S3 bucket the dev namespace,
# which can then be used by a kubernetes job to refresh PoC data.
resource "kubernetes_secret" "s3_bucket_data_refresh" {
  metadata {
    name      = "s3-bucket-output-poc"
    namespace = "hmpps-delius-alfresco-dev"
  }

  data = {
    BUCKET_ARN  = module.s3_bucket.bucket_arn
    BUCKET_NAME = module.s3_bucket.bucket_name
    ACCESSKEY   = aws_iam_access_key.alfresco_user_access.id
    SECRETKEY   = aws_iam_access_key.alfresco_user_access.secret
  }
}


############
# Backups
############

module "s3_backups_bucket" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-s3-bucket?ref=5.1.0"
  team_name              = var.team_name
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace
  versioning             = var.versioning

  lifecycle_rule = [
    {
      enabled = true

      noncurrent_version_transition = [
        {
          days          = var.s3_lifecycle_config["noncurrent_version_transition_days"]
          storage_class = "STANDARD_IA"
        },
        {
          days          = var.s3_lifecycle_config["noncurrent_version_transition_glacier_days"]
          storage_class = "GLACIER"
        },
      ]

      noncurrent_version_expiration = [
        {
          days = var.s3_lifecycle_config["noncurrent_version_expiration_days"]
        },
      ]
    }
  ]
}

resource "kubernetes_secret" "s3_backups_bucket" {
  metadata {
    name      = "s3-backups-bucket-output"
    namespace = var.namespace
  }

  data = {
    BUCKET_ARN  = module.s3_backups_bucket.bucket_arn
    BUCKET_NAME = module.s3_backups_bucket.bucket_name
  }
}


#######################################
# s3 bucket for logging all access reqs
#######################################

module "s3_logging_bucket" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-s3-bucket?ref=5.1.0"
  team_name              = var.team_name
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace
  versioning             = var.versioning
  acl                    = "log-delivery-write"
}

resource "kubernetes_secret" "s3_logging_bucket" {
  metadata {
    name      = "s3-logging-bucket-output"
    namespace = var.namespace
  }

  data = {
    BUCKET_ARN  = module.s3_logging_bucket.bucket_arn
    BUCKET_NAME = module.s3_logging_bucket.bucket_name
  }
}


#######################################
# s3 bucket for OpenSearch snapshots
#######################################

module "s3_opensearch_snapshots_bucket" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-s3-bucket?ref=5.1.0" # use the latest release

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}

resource "kubernetes_secret" "s3_opensearch_snapshots_bucket" {
  metadata {
    name      = "s3-opensearch-snapshots-bucket-output"
    namespace = var.namespace
  }

  data = {
    BUCKET_ARN  = module.s3_opensearch_snapshots_bucket.bucket_arn
    BUCKET_NAME = module.s3_opensearch_snapshots_bucket.bucket_name
    ACCESSKEY   = aws_iam_access_key.opensearch_snapshots.id
    SECRETKEY   = aws_iam_access_key.opensearch_snapshots.secret
  }
}

resource "aws_iam_user" "opensearch_snapshots" {
  name = "${var.namespace}-opensearch_snapshots_user"
  path = "/system/${var.namespace}-opensearch_snapshots_user/"
}

resource "aws_iam_access_key" "opensearch_snapshots" {
  user = aws_iam_user.opensearch_snapshots.name
}

resource "aws_iam_user_policy_attachment" "opensearch_snapshots" {
  policy_arn = module.s3_opensearch_snapshots_bucket.irsa_policy_arn
  user       = aws_iam_user.opensearch_snapshots.name
}
