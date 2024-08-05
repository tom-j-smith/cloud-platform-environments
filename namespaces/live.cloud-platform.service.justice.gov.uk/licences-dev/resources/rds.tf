module "dps_rds" {
  source                      = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=7.0.0"
  vpc_name                    = var.vpc_name
  team_name                   = var.team_name
  business_unit               = var.business_unit
  application                 = var.application
  is_production               = var.is_production
  namespace                   = var.namespace
  environment_name            = var.environment-name
  infrastructure_support      = var.infrastructure_support
  allow_minor_version_upgrade = true
  allow_major_version_upgrade = false
  prepare_for_major_upgrade   = false
  db_instance_class           = "db.t4g.small"
  db_engine_version           = "15.6"
  rds_family                  = "postgres15"
  db_password_rotated_date    = "14-02-2023"

  providers = {
    aws = aws.london
  }
}

resource "random_id" "probation_teams_password" {
  byte_length = 32
}

resource "kubernetes_secret" "dps_rds" {
  metadata {
    name      = "dps-rds-instance-output"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint    = module.dps_rds.rds_instance_endpoint
    database_name            = module.dps_rds.database_name
    database_username        = module.dps_rds.database_username
    database_password        = module.dps_rds.database_password
    rds_instance_address     = module.dps_rds.rds_instance_address
    probation_teams_password = random_id.probation_teams_password.b64_url
  }
}
