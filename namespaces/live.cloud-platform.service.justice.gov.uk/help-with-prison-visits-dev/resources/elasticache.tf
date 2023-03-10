################################################################################
# Help with Prison Visits Elasticache for ReDiS
################################################################################

module "hwpv_elasticache_redis" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=6.0.0"
  vpc_name               = var.vpc_name
  application            = var.application
  environment-name       = var.environment-name
  is-production          = var.is_production
  infrastructure-support = var.infrastructure-support
  team_name              = var.team_name
  number_cache_clusters  = var.number_cache_clusters
  node_type              = "cache.t2.small"
  engine_version         = "7.0"
  parameter_group_name   = "default.redis7"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hwpv_elasticache_redis" {
  metadata {
    name      = "hwpv-elasticache-redis"
    namespace = var.namespace
  }

  data = {
    primary_endpoint_address = module.hwpv_elasticache_redis.primary_endpoint_address
    auth_token               = module.hwpv_elasticache_redis.auth_token
    member_clusters          = jsonencode(module.hwpv_elasticache_redis.member_clusters)
    access_key_id            = module.hwpv_elasticache_redis.access_key_id
    secret_access_key        = module.hwpv_elasticache_redis.secret_access_key
  }
}
