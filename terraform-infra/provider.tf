terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
        }   
    }
}
provider "kubernetes" {
  config_path = "C:/Users/Lenovo/.kube/config"
}

provider "aws" {
  region = var.aws_region
}


