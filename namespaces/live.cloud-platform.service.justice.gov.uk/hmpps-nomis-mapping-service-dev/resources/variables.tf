/*
 * When using this module through the cloud-platform-environments, the following
 * variable is automatically supplied by the pipeline.
 *
 */
variable "vpc_name" {
}

variable "domain" {
  default = "dev.nomis-sync-prisoner-mapping-dev.service.justice.gov.uk"
}

variable "application" {
  default = "hmpps-nomis-mapping-service-dev"
}

variable "namespace" {
  default = "hmpps-nomis-mapping-service-dev"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "HMPPS"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "syscon-devs"
}

variable "environment-name" {
  description = "The type of environment you're deploying to."
  default     = "dev"
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "dps-hmpps@digital.justice.gov.uk"
}

variable "is_production" {
  default = "false"
}

variable "rds-family" {
  default = "postgres14"
}

