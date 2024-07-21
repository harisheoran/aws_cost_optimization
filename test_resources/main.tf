terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

/*
module "ec2" {
    source = "./modules/ec2"
    ami = var.ami
    ec2-name = var.ec2-name
    instance_type = var.instance_type
}
*/

module "snapshots" {
    source = "./modules/snapshots"
    volume_id = "vol-08f40fdc6a4ec83a4"
}
