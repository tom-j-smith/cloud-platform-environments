variable "vpc_name" {
  description = "VPC name to create security groups in for the ElastiCache and RDS modules"
  type        = string
}

variable "kubernetes_cluster" {
  description = "Kubernetes cluster name for references to secrets for service accounts"
  type        = string
}

variable "application" {
  description = "Name of the application you are deploying"
  type        = string
  default     = "laa-crime-evidence"
}

variable "namespace" {
  description = "Name of the namespace these resources are part of"
  type        = string
  default     = "laa-crime-evidence-staging"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for this service"
  type        = string
  default     = "LAA"
}

variable "team_name" {
  description = "Name of the development team responsible for this service"
  type        = string
  default     = "laa-crime-apps-team"
}

variable "environment" {
  description = "Name of the environment type for this service"
  type        = string
  default     = "staging"
}

variable "infrastructure_support" {
  description = "Email address of the team responsible this service"
  type        = string
  default     = "laa-crime-apps@digital.justice.gov.uk"
}

variable "is_production" {
  description = "Whether this environment type is production or not"
  type        = string
  default     = "false"
}

variable "slack_channel" {
  description = "Slack channel name for your team, if we need to contact you about this service"
  type        = string
  default     = "laa-crimeapps-modernisation"
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

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  default     = "crime-evidence-gateway-staging"
}

variable "apigw_stage_name" {
  description = "Named reference to the deployment"
  default     = "v1"
}

variable "user_pool_name" {
  description = "Cognito user pool name"
  default     = "crime-evidence-staging-userpool"
}

variable "cognito_user_pool_ccp_client_name" {
  description = "Cognito user pool CCP client name"
  default     = "crown-court-proceeding-client"
}

variable "resource_server_identifier" {
  description = "Cognito resource server identifier"
  default     = "crime-evidence-staging"
}

variable "resource_server_name" {
  description = "Cognito resource server name"
  default     = "crime-evidence-staging-resource-server"
}

variable "resource_server_scope_name" {
  description = "Resource server scope name"
  default     = "read_write"
}

variable "resource_server_scope_description" {
  default = "read_write scope"
}

variable "cognito_user_pool_domain_name" {
  default = "laa-crime-evidence-dev.apps.live.cloud-platform.service.justice.gov.uk"
}
