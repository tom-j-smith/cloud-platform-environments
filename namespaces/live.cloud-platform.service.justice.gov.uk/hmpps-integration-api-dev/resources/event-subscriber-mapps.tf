module "event_mapps_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=5.0.0"

  # Queue configuration
  sqs_name                  = "events_mapps_queue"
  encrypt_sqs_kms           = "true"
  message_retention_seconds = 1209600

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.event_mapps_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name 
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support

  providers = {
    aws = aws.london_default_github_tag
  }

}

module "event_mapps_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=5.0.0"

  # Queue configuration
  sqs_name        = "event_mapps_queue_dl"
  encrypt_sqs_kms = "true"

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name 
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support

  providers = {
    aws = aws.london_default_github_tag
  }
}

resource "aws_sqs_queue_policy" "event_mapps_queue_policy" {
  queue_url = module.event_mapps_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.event_mapps_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.event_mapps_queue.sqs_arn}",
          "Action": "SQS:SendMessage",
          "Condition":
            {
              "ArnEquals":
                {
                  "aws:SourceArn": "${module.hmpps-integration-events.topic_arn}"
                }
            }
        }
      ]
  }
   EOF
  depends_on = [
    module.hmpps-integration-events
  ]
}


data "aws_secretsmanager_secret" "mapps_filter_list" {
  # NB secret name is generated by secret module and could be change. Current version 3.0.0 does not output the name of the secret.
  name = "live-hmpps-integration-api-dev-68707bf16962536e"
}

data "aws_secretsmanager_secret_version" "mapps_filter_list" {
  secret_id = data.aws_secretsmanager_secret.mapps_filter_list.id
}


resource "aws_sns_topic_subscription" "event_mapps_subscription" {
  provider      = aws.london
  topic_arn     = module.hmpps-integration-events.topic_arn
  protocol      = "sqs"
  endpoint      = module.event_mapps_queue.sqs_arn
  filter_policy = data.aws_secretsmanager_secret_version.mapps_filter_list.secret_string
  depends_on = [
    module.hmpps-integration-events
  ]
}

resource "kubernetes_secret" "event_mapps_queue" {
  metadata {
    name      = "event-mapps-queue"
    namespace = var.namespace
  }

  data = {
    sqs_id                        = module.event_mapps_queue.sqs_id
    sqs_arn                       = module.event_mapps_queue.sqs_arn
    sqs_name                      = module.event_mapps_queue.sqs_name
    mapps_filter_policy_secret_id = data.aws_secretsmanager_secret_version.mapps_filter_list.secret_id
  }
}

resource "kubernetes_secret" "event_mapps_dead_letter_queue" {
  metadata {
    name      = "event-mapps-dl-queue"
    namespace = var.namespace
  }

  data = {
    sqs_id   = module.event_mapps_dead_letter_queue.sqs_id
    sqs_arn  = module.event_mapps_dead_letter_queue.sqs_arn
    sqs_name = module.event_mapps_dead_letter_queue.sqs_name
  }
}
