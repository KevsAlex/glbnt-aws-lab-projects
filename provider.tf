terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = ""
  region  = "us-east-2"
  default_tags {
    tags = {
      application-name = "glbnt-aws-lab-projects"

    }
  }

}