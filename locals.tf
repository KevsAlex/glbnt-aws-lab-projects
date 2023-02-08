locals {
  services = [
    {
      name              = "glbnt-eks-deployments",
      repo-description  = "Deploy eks manifests"
      backend-type      = "eks"
    },
    {
      name              = "glbnt-aws-lab-projects",
      repo-description  = "Creates pipelines"
      backend-type      = "terraform"
    }



  ]

  services-backend = [
  for key, value in local.services : value if (lookup(value, "backend-type", null) == "backend" ? true : false)
  ]

  eks-backend = [
  for key, value in local.services : value if (lookup(value, "backend-type", null) == "eks" ? true : false)
  ]

  terraform-backend = [
  for key, value in local.services : value if (lookup(value, "backend-type", null) == "terraform" ? true : false)
  ]


}
