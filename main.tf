#--------------------------
# Configuracion de Environment
#---------------------------
module "ENV" {
  source      = "./modules/environment"
  environment = var.environment
}

#--------------------------
# Configuracion de Repositorios
#---------------------------
module "CODE-BUILD" {
  source              = "./modules/CODE-BUILD"
  terraform-services  = local.terraform-backend
  environment         = var.environment
  AWS_ACCOUNT_ID      = data.aws_caller_identity.current.account_id
  AWS_DEFAULT_REGION  = data.aws_region.current.name
  compilations        = local.services-backend
  subnets             = module.ENV.subnets
  vpc-id              = module.ENV.vpc-id
  vpc-security-groups = module.ENV.vpc-security-groups
  back-kube-apply     = local.eks-backend
}