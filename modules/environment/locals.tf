locals {

  environments = {
    dev = "stage"
    prod  = "prod"
  }

  #-----------------
  # ID DE LA CUENTA DE AWS
  #-----------------
  AWS_ACCOUNT_ID = {
    dev = "798152040102"
    prod  = "003297768880"
  }

  #-----------------
  # ID DE LAS SUBREDES PRIVADAS
  #-----------------
  subnets = {
    dev = [
      "subnet-083bdc2ff24aa2a1f",
      "subnet-0dd2517753d450874"

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
    dev = "vpc-06c84e618b8462cac"
    prod  = "vpc-0fae6cf7d4296af6f"

  }
  #-----------------
  # SECURITY GROUP DE VPC (Usado para code pipeline)
  #-----------------
  vpc-security-groups = {
    dev = ["sg-03e17a2d49a18d56d"]
    prod  = ["sg-0c758baa9fcf157cc"]
  }




}