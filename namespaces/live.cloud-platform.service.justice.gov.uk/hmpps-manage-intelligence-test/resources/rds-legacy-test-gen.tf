module "rds_aurora_legacy_test_gen" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-rds-aurora?ref=4.0.0"

  # VPC configuration
  vpc_name = var.vpc_name

  # Database configuration
  engine         = "aurora-postgresql"
  engine_version = "15.4"
  engine_mode    = "provisioned"
  instance_type  = "db.serverless"
  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 4
  }
  replica_count = 1

  allow_major_version_upgrade = true

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support

  providers = {
    aws = aws.london
  }
}

resource "random_id" "ims_legacy_test_gen_update_role_password" {
  byte_length = 32
}

resource "random_id" "ims_legacy_test_gen_read_role_password" {
  byte_length = 32
}

resource "kubernetes_secret" "ims_legacy_test_gen_rds_aurora" {
  metadata {
    name      = "ims-legacy-test-gen-rds-aurora-instance-output"
    namespace = var.namespace
  }

  data = {
    rds_cluster_endpoint        = module.rds_aurora_legacy_test_gen.rds_cluster_endpoint
    rds_cluster_reader_endpoint = module.rds_aurora_legacy_test_gen.rds_cluster_reader_endpoint
    db_cluster_identifier       = module.rds_aurora_legacy_test_gen.db_cluster_identifier
    database_name               = module.rds_aurora_legacy_test_gen.database_name
    database_username           = module.rds_aurora_legacy_test_gen.database_username
    database_password           = module.rds_aurora_legacy_test_gen.database_password
    ims_legacy_update_password  = random_id.ims_legacy_test_gen_update_role_password.b64_url
    ims_legacy_read_password    = random_id.ims_legacy_test_gen_read_role_password.b64_url
    url                         = "postgres://${module.rds_aurora_legacy_test_gen.database_username}:${module.rds_aurora_legacy_test_gen.database_password}@${module.rds_aurora_legacy_test_gen.rds_cluster_endpoint}/${module.rds_aurora_legacy_test_gen.database_name}"
    reader_url                  = "postgres://${module.rds_aurora_legacy_test_gen.database_username}:${module.rds_aurora_legacy_test_gen.database_password}@${module.rds_aurora_legacy_test_gen.rds_cluster_reader_endpoint}/${module.rds_aurora_legacy.database_name}"
  }
}
