module "migration_activities_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=5.0.0"

  # Queue configuration
  sqs_name                   = "migration_activities_queue"
  encrypt_sqs_kms            = "true"
  message_retention_seconds  = 345600
  visibility_timeout_seconds = 120

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.migration_activities_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }

EOF

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name # also used for naming the queue
  namespace              = var.namespace
  environment_name       = var.environment_name
  infrastructure_support = var.infrastructure_support
}

module "migration_activities_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=5.0.0"

  # Queue configuration
  sqs_name        = "migration_activities_dlq"
  encrypt_sqs_kms = "true"

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name # also used for naming the queue
  namespace              = var.namespace
  environment_name       = var.environment_name
  infrastructure_support = var.infrastructure_support
}

resource "kubernetes_secret" "migration_activities_queue" {
  metadata {
    name      = "sqs-migration-activities-queue"
    namespace = var.namespace
  }

  data = {
    sqs_id   = module.migration_activities_queue.sqs_id
    sqs_arn  = module.migration_activities_queue.sqs_arn
    sqs_name = module.migration_activities_queue.sqs_name
  }
}

resource "kubernetes_secret" "migration_activities_dead_letter_queue" {
  metadata {
    name      = "sqs-migration-activities-dlq"
    namespace = var.namespace
  }

  data = {
    sqs_id   = module.migration_activities_dead_letter_queue.sqs_id
    sqs_arn  = module.migration_activities_dead_letter_queue.sqs_arn
    sqs_name = module.migration_activities_dead_letter_queue.sqs_name
  }
}
