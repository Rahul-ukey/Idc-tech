terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = "AKIATJQD3LG23K3MKCWQ"
  secret_key = "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"
}