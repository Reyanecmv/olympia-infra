terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

#   backend "s3" {
    # Uncomment and configure for production
    # bucket         = "terraform-state-parking-app"
    # key            = "prod/terraform.tfstate"
    # region         = "eu-central-1"
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
#   }
}