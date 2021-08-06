module "create_link_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name          = var.environment_name
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "create-link-queue"
  encrypt_sqs_kms           = var.encrypt_sqs_kms
  message_retention_seconds = var.message_retention_seconds
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.create_link_queue_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}


resource "aws_sqs_queue_policy" "create_link_queue_policy" {
  queue_url = module.create_link_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.create_link_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Sid": "PublishPolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.create_link_queue.sqs_arn}",
          "Action": "sqs:SendMessage"
        },
        {
          "Sid": "ConsumePolicy",
          "Effect": "Allow",
          "Principal": {
          "AWS": [
            "140455166311"
              ]
          },
          "Resource": "${module.create_link_queue.sqs_arn}",
          "Action": "sqs:ReceiveMessage"
        }
      ]
  }
   EOF
}


module "create_link_queue_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name       = var.environment_name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "create-link-queue-dl"
  existing_user_name     = module.create_link_queue.user_name
  encrypt_sqs_kms        = var.encrypt_sqs_kms
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

module "unlink_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name          = var.environment_name
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "unlink-queue"
  existing_user_name        = module.create_link_queue.user_name
  encrypt_sqs_kms           = var.encrypt_sqs_kms
  message_retention_seconds = var.message_retention_seconds
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.unlink_queue_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "unlink_queue_policy" {
  queue_url = module.unlink_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.unlink_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Sid": "PublishPolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.unlink_queue.sqs_arn}",
          "Action": "sqs:SendMessage"
        },
        {
          "Sid": "ConsumePolicy",
          "Effect": "Allow",
          "Principal": {
          "AWS": [
            "140455166311"
              ]
          },
          "Resource": "${module.unlink_queue.sqs_arn}",
          "Action": "sqs:ReceiveMessage"
        }
      ]
  }
   EOF
}

module "unlink_queue_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name       = var.environment_name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "unlink-queue-dl"
  existing_user_name     = module.create_link_queue.user_name
  encrypt_sqs_kms        = var.encrypt_sqs_kms
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

module "hearing_resulted_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name          = var.environment_name
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "hearing-resulted-queue"
  existing_user_name        = module.create_link_queue.user_name
  encrypt_sqs_kms           = var.encrypt_sqs_kms
  message_retention_seconds = var.message_retention_seconds
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.hearing_resulted_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "hearing_resulted_queue_policy" {
  queue_url = module.hearing_resulted_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.hearing_resulted_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Sid": "PublishPolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.hearing_resulted_queue.sqs_arn}",
          "Action": "sqs:SendMessage"
        },
        {
          "Sid": "ConsumePolicy",
          "Effect": "Allow",
          "Principal": {
          "AWS": [
            "140455166311"
              ]
          },
          "Resource": "${module.hearing_resulted_queue.sqs_arn}",
          "Action": "sqs:ReceiveMessage"
        }
      ]
  }
   EOF
}

module "hearing_resulted_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name       = var.environment_name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "hearing-resulted-queue-dl"
  existing_user_name     = module.create_link_queue.user_name
  encrypt_sqs_kms        = var.encrypt_sqs_kms
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

module "create_link_cp_status_job_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name          = var.environment_name
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "create-link-cp-status-job-queue"
  existing_user_name        = module.create_link_queue.user_name
  encrypt_sqs_kms           = var.encrypt_sqs_kms
  message_retention_seconds = var.message_retention_seconds
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.create_link_cp_status_job_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "create-link-cp-status-job-queue_policy" {
  queue_url = module.create_link_cp_status_job_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.create_link_cp_status_job_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Sid": "PublishPolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.create_link_cp_status_job_queue.sqs_arn}",
          "Action": "sqs:SendMessage"
        },
        {
          "Sid": "ConsumePolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.create_link_cp_status_job_queue.sqs_arn}",
          "Action": "sqs:ReceiveMessage"
        }
      ]
  }
   EOF
}

module "create_link_cp_status_job_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name       = var.environment_name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "create-link-cp-status-job-queue-dl"
  existing_user_name     = module.create_link_queue.user_name
  encrypt_sqs_kms        = var.encrypt_sqs_kms
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

module "cp_laa_status_job_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name          = var.environment_name
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "cp-laa-status-job-queue"
  existing_user_name        = module.create_link_queue.user_name
  encrypt_sqs_kms           = var.encrypt_sqs_kms
  message_retention_seconds = var.message_retention_seconds
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.cp_laa_status_job_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "cp_laa_status_job_queue_policy" {
  queue_url = module.cp_laa_status_job_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.cp_laa_status_job_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Sid": "PublishPolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.cp_laa_status_job_queue.sqs_arn}",
          "Action": "sqs:SendMessage"
        },
        {
          "Sid": "ConsumePolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.cp_laa_status_job_queue.sqs_arn}",
          "Action": "sqs:ReceiveMessage"
        }
      ]
  }
   EOF
}

module "cp_laa_status_job_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name       = var.environment_name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "cp-laa-status-job-queue-dl"
  existing_user_name     = module.create_link_queue.user_name
  encrypt_sqs_kms        = var.encrypt_sqs_kms
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

module "prosecution_concluded_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name          = var.environment_name
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "prosecution-concluded-queue"
  existing_user_name        = module.create_link_queue.user_name
  encrypt_sqs_kms           = var.encrypt_sqs_kms
  message_retention_seconds = var.message_retention_seconds
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.prosecution_concluded_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}

module "prosecution_concluded_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.3"

  environment-name       = var.environment_name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "prosecution-concluded-queue-dl"
  encrypt_sqs_kms        = var.encrypt_sqs_kms
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "prosecution_concluded_queue_policy" {
  queue_url = module.prosecution_concluded_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.prosecution_concluded_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Sid": "PublishPolicy",
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.prosecution_concluded_queue.sqs_arn}",
          "Action": "sqs:SendMessage"
        },
        {
          "Sid": "ConsumePolicy",
          "Effect": "Allow",
          "Principal": {
          "AWS": [
            "140455166311"
              ]
          },
          "Resource": "${module.prosecution_concluded_queue.sqs_arn}",
          "Action": "sqs:ReceiveMessage"
        }
      ]
  }
   EOF
}

resource "kubernetes_secret" "create_link_queue" {
  metadata {
    name      = "cda-messaging-queues-output"
    namespace = var.namespace
  }

  data = {
    access_key_id                        = module.create_link_queue.access_key_id
    secret_access_key                    = module.create_link_queue.secret_access_key
    sqs_url_link                         = module.create_link_queue.sqs_id
    sqs_arn_link                         = module.create_link_queue.sqs_arn
    sqs_name_link                        = module.create_link_queue.sqs_name
    sqs_url_d_link                       = module.create_link_queue_dead_letter_queue.sqs_id
    sqs_arn_d_link                       = module.create_link_queue_dead_letter_queue.sqs_arn
    sqs_name_d_link                      = module.create_link_queue_dead_letter_queue.sqs_name
    sqs_url_unlink                       = module.unlink_queue.sqs_id
    sqs_arn_unlink                       = module.unlink_queue.sqs_arn
    sqs_name_unlink                      = module.unlink_queue.sqs_name
    sqs_url_d_unlink                     = module.unlink_queue_dead_letter_queue.sqs_id
    sqs_arn_d_unlink                     = module.unlink_queue_dead_letter_queue.sqs_arn
    sqs_name_d_unlink                    = module.unlink_queue_dead_letter_queue.sqs_name
    sqs_url_hearing_resulted             = module.hearing_resulted_queue.sqs_id
    sqs_arn_hearing_resulted             = module.hearing_resulted_queue.sqs_arn
    sqs_name_hearing_resulted            = module.hearing_resulted_queue.sqs_name
    sqs_url_d_hearing_resulted           = module.hearing_resulted_dead_letter_queue.sqs_id
    sqs_arn_d_hearing_resulted           = module.hearing_resulted_dead_letter_queue.sqs_arn
    sqs_name_d_hearing_resulted          = module.hearing_resulted_dead_letter_queue.sqs_name
    sqs_url_prosecution_concluded        = module.prosecution_concluded_queue.sqs_id
    sqs_arn_prosecution_concluded        = module.prosecution_concluded_queue.sqs_arn
    sqs_name_prosecution_concluded       = module.prosecution_concluded_queue.sqs_name
    sqs_url_d_prosecution_concluded      = module.prosecution_concluded_dead_letter_queue.sqs_id
    sqs_arn_d_prosecution_concluded      = module.prosecution_concluded_dead_letter_queue.sqs_arn
    sqs_name_d_prosecution_concluded     = module.prosecution_concluded_dead_letter_queue.sqs_name
    sqs_url_cp_create_link_status_job    = module.create_link_cp_status_job_queue.sqs_id
    sqs_arn_cp_create_link_status_job    = module.create_link_cp_status_job_queue.sqs_arn
    sqs_name_cp_create_link_status_job   = module.create_link_cp_status_job_queue.sqs_name
    sqs_url_d_cp_create_link_status_job  = module.create_link_cp_status_job_dead_letter_queue.sqs_id
    sqs_arn_d_cp_create_link_status_job  = module.create_link_cp_status_job_dead_letter_queue.sqs_arn
    sqs_name_d_cp_create_link_status_job = module.create_link_cp_status_job_dead_letter_queue.sqs_name
    sqs_url_cp_laa_status_job            = module.cp_laa_status_job_queue.sqs_id
    sqs_arn_cp_laa_status_job            = module.cp_laa_status_job_queue.sqs_arn
    sqs_name_cp_laa_status_job           = module.cp_laa_status_job_queue.sqs_name
    sqs_url_d_cp_laa_status_job          = module.cp_laa_status_job_dead_letter_queue.sqs_id
    sqs_arn_d_cp_laa_status_job          = module.cp_laa_status_job_dead_letter_queue.sqs_arn
    sqs_name_d_cp_laa_status_job         = module.cp_laa_status_job_dead_letter_queue.sqs_name

  }
}
