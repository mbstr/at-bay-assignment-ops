terraform {
  required_version = "~> 1.9.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.71.0"
    }
  }
}

provider "aws" {
  region     = var.hello_world_deployment_region
}
