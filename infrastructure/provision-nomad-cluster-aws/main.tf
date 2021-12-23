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
  ami_id       = "ami-0f280560b98fea7f0"
  cluster_name = "polymath-THA-nomad-cluster"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.nomad.security_group_id_clients
}