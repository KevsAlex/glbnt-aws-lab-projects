#-----------------
# OUTPUTS
#-----------------

output AWS_ACCOUNT_ID{
  value = local.AWS_ACCOUNT_ID[var.environment]
}

output subnets {
  value = local.subnets[var.environment]
}

output vpc-id{
  value = local.vpc-id[var.environment]
}


output vpc-security-groups{
  value = local.vpc-security-groups[var.environment]
}


