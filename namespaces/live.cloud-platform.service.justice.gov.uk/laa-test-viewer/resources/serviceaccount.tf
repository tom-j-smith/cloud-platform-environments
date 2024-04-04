module "serviceaccount" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-serviceaccount?ref=1.1.0"

  namespace            = var.namespace
  kubernetes_cluster   = var.kubernetes_cluster
  serviceaccount_rules = var.serviceaccount_rules

  # Uncomment and provide repository names to create github actions secrets
  # containing the ca.crt and token for use in github actions CI/CD pipelines
  # using default service account name
  github_repositories = ["laa-test-viewer"]
  serviceaccount_name = "cd-serviceaccount"
}
