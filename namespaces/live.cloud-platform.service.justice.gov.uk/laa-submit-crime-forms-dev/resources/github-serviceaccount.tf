module "serviceaccount_github" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-serviceaccount?ref=1.1.0"

  namespace            = var.namespace
  kubernetes_cluster   = var.kubernetes_cluster
  serviceaccount_name  = "github-actions"
  serviceaccount_rules = var.serviceaccount_rules
  role_name            = "github-actions-role"
  rolebinding_name     = "github-action-rolebinding"

  # Uncomment and provide repository names to create github actions secrets
  # containing the ca.crt and token for use in github actions CI/CD pipelines
  github_repositories                  = [var.repo_name]
  github_actions_secret_kube_cert      = "AUTOGENERATED_SUBMIT_FORMS_DEV_K8S_CLUSTER_CERT"
  github_actions_secret_kube_token     = "AUTOGENERATED_SUBMIT_FORMS_DEV_K8S_TOKEN"
  github_actions_secret_kube_cluster   = "AUTOGENERATED_SUBMIT_FORMS_DEV_K8S_CLUSTER_NAME"
  github_actions_secret_kube_namespace = "AUTOGENERATED_SUBMIT_FORMS_DEV_K8S_NAMESPACE"
}