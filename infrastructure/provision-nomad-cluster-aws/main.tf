terraform {
  backend "s3" {
    bucket  = "cmps-polymath-tf-backend-statefiles"
    key     = "nomad-exercise/dev/statefile"
    region  = "eu-west-1"
    #profile = "default"
  }

  required_version = ">= 0.12.26"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

module "nomad" {
  source       = "hashicorp/nomad/aws"
  version      = "0.10.0"
  ami_id       = "ami-04fcff3bed161226f"
  cluster_name = "polymath-THA-nomad-cluster"
}