################### VARIABLES ##############################
variable "name" {
  type    = string
  default = "Terraform-state"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # define region as per your account
}

resource "aws_instance" "test" {
  ami                         = "ami-052efd3df9dad4825"
  instance_type               = "t2.micro"
  user_data              = file("userdata.tpl")
  tags = {
    Name = var.name
  }
}

# Default VPC
resource "aws_default_vpc" "default" {

}

################### SECURITY GROUP ##########################
resource "aws_security_group" "test" {
  name        = "demo_sg"
  description = "Allow TLS inbound traffic"
  ingress {
    description = "allow access to web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.name
  }
}

resource "aws_s3_bucket" "terraform-test-bucket-sheharyar" {
  bucket = "demo-github-action-tf-medium-sheharyar"

  object_lock_enabled = false

  tags = {
    Environment = "Prod"
  }
}
