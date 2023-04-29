
terraform {
  required_version = ">= 1.2.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    pingdom = {
      source  = "DrFaust92/pingdom"
      version = "~> 1.3.1"
    }
  }
}
