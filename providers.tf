terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }

    docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_key"
  secret_key                  = "mock_secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ecs = "http://localhost:4566"
    ecr = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

provider "docker" {}