#-----------------
# LISTA DE REPOSITORIOS
#-----------------
variable compilations {
  type    = list(map(string))
  default = [
    {
      name = "image-1234",
      port = 8421
    }
  ]
}

variable "AWS_ACCOUNT_ID" {
  description = "AWS_ACCOUNT_ID"
  type        = string
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS_ACCOUNT_ID"
  type        = string
}

#-----------------
# SUBREDES PRIVADAS
#-----------------
variable "subnets" {
  description = "Subredes privadas"
  type        = list(string)
}

#-----------------
# AMBIENTE (stage , prod)
#-----------------
variable "environment" {
  type = string
}

#-----------------
# Id de la vpc
#-----------------
variable vpc-id {
  type = string
}

#-----------------
# Secuirty groups de la vpc
#-----------------
variable vpc-security-groups {
  type = list(string)
}

#-----------------
# PIPELINE EKS deployment
#-----------------
variable back-kube-apply {
  type    = list(map(string))
  default = [
    {
      name = "image-1234",
      port = 8421
    }
  ]

}

variable terraform-services {
  type    = list(map(string))
  default = [
    {
      name = "image-1234",
      port = 8421
    }
  ]

}

