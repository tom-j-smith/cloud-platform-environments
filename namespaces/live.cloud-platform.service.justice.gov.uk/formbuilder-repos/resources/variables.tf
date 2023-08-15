variable "lifecycle_policy" {
  default = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep the newest 50 images and mark the rest for expiration",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

variable "scan_on_push" {
  default = "true"
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

variable "namespace" {
  description = "Name of the namespace these resources are part of"
  type        = string
  default     = "formbuilder-repos"
}

variable "team_name" {
  default = "formbuilder"
}
