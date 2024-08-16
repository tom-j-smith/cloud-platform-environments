module "rds_mssql" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=7.0.0"

  # VPC configuration
  vpc_name = var.vpc_name

  # RDS configuration
  allow_minor_version_upgrade  = true
  allow_major_version_upgrade  = false
  performance_insights_enabled = false
  db_max_allocated_storage     = "500"
  # enable_rds_auto_start_stop   = true # Uncomment to turn off your database overnight between 10PM and 6AM UTC / 11PM and 7AM BST.
  # db_password_rotated_date     = "2023-04-17" # Uncomment to rotate your database password.

  # SQL Server specifics
  db_engine                = "oracle-se2" # or oracle-ee
#   db_engine_version        = "19.0.0.0.ru-2024-04.rur-2024-04.r1"
  db_engine_version        = "19.0.0.0"
  rds_family               = "oracle-se2-19"
  db_instance_class        = "db.t3.medium"
  db_allocated_storage = 32 # minimum of 20GiB for SQL Server

  # Some engines can't apply some parameters without a reboot(ex SQL Server cant apply force_ssl immediate).
  # You will need to specify "pending-reboot" here, as default is set to "immediate".


  # Tags
  application            = var.application
  business_unit          = var.business_unit
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  is_production          = var.is_production
  namespace              = var.namespace
  team_name              = var.team_name
}

resource "kubernetes_secret" "rds_mssql" {
  metadata {
    name      = "rds-mssql-instance-output"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint = module.rds_mssql.rds_instance_endpoint
    database_username     = module.rds_mssql.database_username
    database_password     = module.rds_mssql.database_password
    rds_instance_address  = module.rds_mssql.rds_instance_address
  }
}