terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    sra = {
      source  = "BeyondTrust/sra"
      version = "~> 1.0.0"
    }
    passwordsafe = {
      source = "beyondtrust/passwordsafe"
      version = "1.0.1"  
    }
  }
}