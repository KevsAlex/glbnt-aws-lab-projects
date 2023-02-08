#--------------------------
# Code build config
#---------------------------

resource "aws_codebuild_project" code-terraform-projects {
  //TODO : USAR LOS PROYECTOS DE TERRAFORM
  for_each = {
  for compilation in var.terraform-services :  compilation.name => compilation
  }
  name           = each.key
  service_role   = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/service-role/codebuild-terraform-service-role"
  source_version = "refs/heads/master"
  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"

  }
  cache {
    modes = []
    type  = "NO_CACHE"
  }
  environment {

    compute_type    = "BUILD_GENERAL1_SMALL"
    privileged_mode = true
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = var.AWS_ACCOUNT_ID
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = var.AWS_DEFAULT_REGION
    }

    environment_variable {
      name  = "AWS_ENVIRONMENT"
      type  = "PLAINTEXT"
      value = var.environment
    }

    environment_variable {
      name  = "TF_VERSION"
      type  = "PLAINTEXT"
      value = "1.3.6"
    }

    #environment_variable {
    #  name  = "TFSTATE_BUCKET"
    #  type  = "PLAINTEXT"
    #  value = local.terraform-bucket-name[var.environment]
    #}

    environment_variable {
      name  = "TF_ACTION"
      type  = "PLAINTEXT"
      value = "plan"
    }

  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/KevsAlex/glbnt-aws-lab-projects.git"
    git_clone_depth = 1
    insecure_ssl    = false
    git_submodules_config {
      fetch_submodules = true
    }
  }

  vpc_config {
    security_group_ids = var.vpc-security-groups
    subnets            = var.subnets
    vpc_id             = var.vpc-id
  }
  tags = {}
}


