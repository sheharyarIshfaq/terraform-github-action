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


resource "aws_instance" "aws_ubuntu" {
  instance_type          = "t2.micro"
  ami                    = "ami-052efd3df9dad4825"
  user_data              = file("userdata.tpl")
}  


# Default VPC
resource "aws_default_vpc" "default" {

}

# Security group
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "allow ssh on 22 & http on port 80"
#   vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}



# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}

resource "aws_s3_bucket" "terraform-test-bucket-sheharyar" {
  bucket = "demo-github-action-tf-medium-sheharyar"

  object_lock_enabled = false

  tags = {
    Environment = "Prod"
  }
}
