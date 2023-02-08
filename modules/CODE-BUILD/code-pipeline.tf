#--------------------------
# Pipelines
#---------------------------

locals {
  source_role_arn = var.environment == "dev" ? null : "arn:aws:iam::798152040102:role/deleteme-crossaccount-role"

  #--------------------------
  # KMS Key for allowing access to prod s3 bucket
  #---------------------------
  kms_key_info= {
    dev = {
      id = null
      type = null
    }

    #prod = {
    #  id = try(aws_kms_key.kms-allow-s3-write[0].arn,null)
    #  type = "KMS"
    #}
  }

  repo-branch-trigger = {
    dev = "master"
    prod  = "production"
  }
}

#--------------------------
# EKS deploy pipeline
#---------------------------

resource "aws_codepipeline" pipeline-kube-apply {
  for_each = aws_iam_role.pipeline-roles-kube-apply
  name     = "${each.key}-${var.environment}"
  role_arn = each.value.arn

  artifact_store {
    #location = "codepipeline-${var.AWS_DEFAULT_REGION}-518971726053"
    location = aws_s3_bucket.pipeline-log-bucket.bucket
    type     = "S3"
    #dynamic encryption_key {
#
    #  for_each = var.environment == "dev" ? [] : [true]
    #  content {
    #    id   = local.kms_key_info[var.environment]["id"]
    #    type = local.kms_key_info[var.environment]["type"]
    #  }
    #}

  }

  stage {
    name = local.SOURCE

    action {

      name          = local.SOURCE
      configuration = {
        BranchName           = local.repo-branch-trigger[var.environment]
        OutputArtifactFormat = "CODE_ZIP"
        PollForSourceChanges = true
        RepositoryName       = each.key
      }
      #role_arn         = local.source_role_arn
      input_artifacts  = []
      category         = local.SOURCE
      output_artifacts = [
        "SourceArtifact"
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      region    = var.AWS_DEFAULT_REGION
      run_order = 1
      version   = "1"


    }
  }

  stage {
    name = local.BUILD

    action {
      name      = local.BUILD
      namespace = "BuildVariables"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = var.AWS_DEFAULT_REGION
      run_order = 1
      version   = "1"

      input_artifacts = [
        "SourceArtifact"
      ]
      output_artifacts = [
        "BuildArtifact"
      ]


      configuration = {
        ProjectName = each.key
        #EnvironmentVariables = jsonencode([
        #  {
        #    name  = "AWS_ACCOUNT_ID"
        #    type  = "PLAINTEXT"
        #    value = var.AWS_ACCOUNT_ID
        #  },
        #  {
        #    name  = "IMAGE_REPO_NAME"
        #    type  = "PLAINTEXT"
        #    value = each.key
        #  },
        #  {
        #    name  = "IMAGE_TAG"
        #    type  = "PLAINTEXT"
        #    value = "latest"
        #  },
        #  {
        #    name : "CONT_NAME",
        #    type = "PLAINTEXT"
        #    value : each.key
        #  }
        #])
      }
    }


  }

  #stage {
  #  name = "Approval"
  #
  #  action {
  #    category  = "Approval"
  #    name      = "ManualApproval"
  #    owner     = "AWS"
  #    provider  = "Manual"
  #    region    = var.AWS_DEFAULT_REGION
  #    run_order = 1
  #    version   = "1"
  #
  #    input_artifacts  = []
  #    output_artifacts = []
  #
  #
  #    configuration = {
  #      NotificationArn = "arn:aws:sns:us-east-1:798152040102:repository-notifications-manual"
  #    }
  #  }
  #}



}

resource "aws_codepipeline" pipeline-terraform {
  for_each = aws_iam_role.pipeline-roles-terraform
  name     = "${each.key}-${var.environment}"
  role_arn = each.value.arn

  artifact_store {
    #location = "codepipeline-${var.AWS_DEFAULT_REGION}-518971726053"
    location = aws_s3_bucket.pipeline-log-bucket.bucket
    type     = "S3"
    dynamic encryption_key {

      #If its prod , config kms key to access stage repos
      for_each = var.environment == "dev" ? [] : [true]
      content {
        id   = local.kms_key_info[var.environment]["id"]
        type = local.kms_key_info[var.environment]["type"]
      }
    }

  }

  stage {
    name = local.SOURCE

    action {

      name          = local.SOURCE
      configuration = {
        BranchName           = local.repo-branch-trigger[var.environment]
        OutputArtifactFormat = "CODE_ZIP"
        PollForSourceChanges = true
        RepositoryName       = each.key
      }
      role_arn         = local.source_role_arn
      input_artifacts  = []
      category         = local.SOURCE
      output_artifacts = [
        "SourceArtifact"
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      region    = var.AWS_DEFAULT_REGION
      run_order = 1
      version   = "1"


    }
  }

  stage {
    name = local.BUILD

    action {
      name      = local.BUILD
      namespace = "BuildVariables"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = var.AWS_DEFAULT_REGION
      run_order = 1
      version   = "1"

      input_artifacts = [
        "SourceArtifact"
      ]
      output_artifacts = [
        "BuildArtifact"
      ]


      configuration = {
        ProjectName = each.key
        EnvironmentVariables = jsonencode([
          # In case we change to bucket state
          #{
          #  name  = "TFSTATE_BUCKET"
          #  type  = "PLAINTEXT"
          #  value = local.terraform-bucket-name[var.environment]
          #},
          {
            name  = "TF_ACTION"
            type  = "PLAINTEXT"
            value = "plan"
          }
        ])
      }
    }


  }

  stage {
    name = "Approval"

    action {
      category  = "Approval"
      name      = "ManualApproval"
      owner     = "AWS"
      provider  = "Manual"
      region    = var.AWS_DEFAULT_REGION
      run_order = 1
      version   = "1"

      input_artifacts  = []
      output_artifacts = []


      configuration = {
        #NotificationArn = "arn:aws:sns:us-east-1:798152040102:repository-notifications-manual"
        ExternalEntityLink = "https://example.com"
        #NotificationArn = "arn:aws:sns:us-east-1:798152040102:CodeStarNotifications-deployment-notifications-5c98bb77192f3b5102a6be9d1d02d7a176e82a5f"
        CustomData = "random comments"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      category  = "Build"
      name      = "Deploy"
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = var.AWS_DEFAULT_REGION
      run_order = 1
      version   = "1"

      input_artifacts  = ["SourceArtifact"]
      output_artifacts = []


      configuration = {
        ProjectName          = each.key
        EnvironmentVariables = jsonencode([
          #{
          #  name  = "TFSTATE_BUCKET"
          #  type  = "PLAINTEXT"
          #  value = local.terraform-bucket-name[var.environment]
          #},
          {
            name  = "TF_ACTION"
            type  = "PLAINTEXT"
            value = "apply -auto-approve"
          }
        ])
      }
    }
  }





}





