#--------------------------
# Code build config
#---------------------------

resource "aws_codebuild_project" code-terraform-projects {

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
    location        = "https://github.com/${var.GIT_HUB_ACCOUNT}/${each.key}.git"
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


resource "aws_codebuild_project" code-compilations-kube-apply {
  for_each       = aws_iam_role.compilation-roles-kube-apply
  name           = each.key
  service_role   = each.value["arn"]
  source_version = "refs/heads/master"//"refs/heads/staging"
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
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = each.key
    }

    environment_variable {
      name  = "CONT_NAME"
      type  = "PLAINTEXT"
      value = each.key
    }

    environment_variable {
      name  = "AWS_ENVIRONMENT"
      type  = "PLAINTEXT"
      value = var.environment
    }

    environment_variable {
      name  = "EKS_KUBECTL_ROLE_ARN"
      value = local.eks-role[var.environment]
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = local.eks-cluster-name[var.environment]
      type  = "PLAINTEXT"
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
    location        = "https://github.com/${var.GIT_HUB_ACCOUNT}/${each.key}.git"
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

locals {


  eks-role = {
    dev = "arn:aws:iam::448500023013:role/EksCodeBuildKubectlRole"
    prod  = "arn:aws:iam::003297768880:role/EksCodeBuildKubectlRole"
  }

  eks-cluster-name = {
    dev = "lmk-cluster-dev"
    prod  = "lmk-cluster-dev"
  }


  repo-branch = {
    stage = "refs/heads/master"
    prod  = "refs/heads/production"
  }


}