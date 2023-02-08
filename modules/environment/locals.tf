locals {

  environments = {
    dev = "dev"
    prod  = "prod"
  }

  #-----------------
  # ID DE LA CUENTA DE AWS
  #-----------------
  AWS_ACCOUNT_ID = {
    dev = "448500023013"
    prod  = "003297768880"
  }

  #-----------------
  # ID DE LAS SUBREDES PRIVADAS
  #-----------------
  subnets = {
    dev = [
      "subnet-0aa432c826355bbec",
      "subnet-0e581e629c2a22424"

    ]
    prod = [
      "subnet-0d44f680b2456ed0c",
      "subnet-03a9b268ec92a1477"
    ]
  }

  #-----------------
  # ID DE LA VPC
  #-----------------
  vpc-id = {
    dev = "vpc-0d7dd169529239fed"
    prod  = "vpc-0fae6cf7d4296af6f"

  }
  #-----------------
  # SECURITY GROUP DE VPC (Usado para code pipeline)
  #-----------------
  vpc-security-groups = {
    dev = ["sg-005cf679b06e2139c"]
    prod  = ["sg-0c758baa9fcf157cc"]
  }




}