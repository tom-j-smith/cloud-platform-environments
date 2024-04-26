variable "vpc_name" {
  description = "VPC name to create security groups in for the ElastiCache and RDS modules"
  type        = string
}

variable "kubernetes_cluster" {
  description = "Kubernetes cluster name for references to secrets for service accounts"
  type        = string
}

variable "eks_cluster_name" {
}

variable "application" {
  description = "Name of the application you are deploying"
  type        = string
  default     = "request-personal-information"
}

variable "namespace" {
  description = "Name of the namespace these resources are part of"
  type        = string
  default     = "request-personal-information-staging"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for this service"
  type        = string
  default     = "HQ"
}

variable "team_name" {
  description = "Name of the development team responsible for this service"
  type        = string
  default     = "central-digital-product-team"
}

variable "repo_name" {
  default = "request-personal-information"
}

variable "environment" {
  description = "Name of the environment type for this service"
  type        = string
  default     = "staging"
}

variable "infrastructure_support" {
  description = "Email address of the team responsible this service"
  type        = string
  default     = "central-digital-product-team@digital.justice.gov.uk"
}

variable "is_production" {
  description = "Whether this environment type is production or not"
  type        = string
  default     = "false"
}

variable "slack_channel" {
  description = "Slack channel name for your team, if we need to contact you about this service"
  type        = string
  default     = "cdpt-request-personal-information"
}

variable "github_owner" {
  description = "The GitHub organization or individual user account containing the app's code repo. Used by the Github Terraform provider. See: https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/ecr-setup.html#accessing-the-credentials"
  type        = string
  default     = "ministryofjustice"
}

variable "github_token" {
  type        = string
  description = "Required by the GitHub Terraform provider"
  default     = ""
}