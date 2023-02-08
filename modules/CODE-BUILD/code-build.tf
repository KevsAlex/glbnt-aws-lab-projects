#--------------------------
# Code build config
#---------------------------

#resource "aws_codebuild_project" code-terraform-projects {
#  //TODO : USAR LOS PROYECTOS DE TERRAFORM
#
#  name           = "sdas"
#  service_role   = "arn:aws:iam::798152040102:role/service-role/codebuild-terraform-service-role"
#  source_version = "refs/heads/staging"
#  artifacts {
#    encryption_disabled    = false
#    override_artifact_name = false
#    type                   = "NO_ARTIFACTS"
#
#  }
#  cache {
#    modes = []
#    type  = "NO_CACHE"
#  }
#  environment {
#
#    compute_type    = "BUILD_GENERAL1_SMALL"
#    privileged_mode = true
#    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
#    type            = "LINUX_CONTAINER"
#
#    environment_variable {
#      name  = "AWS_ACCOUNT_ID"
#      type  = "PLAINTEXT"
#      value = var.AWS_ACCOUNT_ID
#    }
#
#    environment_variable {
#      name  = "AWS_DEFAULT_REGION"
#      type  = "PLAINTEXT"
#      value = var.AWS_DEFAULT_REGION
#    }
#
#    environment_variable {
#      name  = "AWS_ENVIRONMENT"
#      type  = "PLAINTEXT"
#      value = var.environment
#    }
#
#    environment_variable {
#      name  = "TF_VERSION"
#      type  = "PLAINTEXT"
#      value = "1.3.6"
#    }
#
#    environment_variable {
#      name  = "TF_ACTION"
#      type  = "PLAINTEXT"
#      value = "plan"
#    }
#
#  }
#
#  logs_config {
#    cloudwatch_logs {
#      status = "ENABLED"
#    }
#    s3_logs {
#      encryption_disabled = false
#      status              = "DISABLED"
#    }
#  }
#
#   source {
#     type            = "GITHUB"
#     location        = "https://github.com/mitchellh/packer.git"
#     git_clone_depth = 1
#
#     git_submodules_config {
#       fetch_submodules = true
#     }
#  }
#
#  vpc_config {
#    security_group_ids = var.vpc-security-groups
#    subnets            = var.subnets
#    vpc_id             = var.vpc-id
#  }
#  tags = {}
#}
#
#
#