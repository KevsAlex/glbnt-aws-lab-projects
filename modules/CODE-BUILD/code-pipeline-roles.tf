resource "aws_iam_role" "compilation-roles" {
  for_each = {for target in local.compilation-policies:  target["name"] => target}
  name = "codebuild-${each.key}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }


    ]
  })
  managed_policy_arns = [
    each.value["policies"]["arn"],
    each.value["ecrAccess"]["arn"],
    each.value["vpc_policie"]["arn"],
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    aws_iam_policy.CodeBuildBase-KMS-access.arn,
    aws_iam_policy.policie-repo-access.arn
  ]
  path = "/service-role/"

  tags = {

  }
}

resource "aws_iam_role" "compilation-roles-kube-apply" {
  for_each = {for target in local.compilation-policies-kube-apply:  target["name"] => target}
  name = "codebuild-${each.key}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }


    ]
  })
  managed_policy_arns = [
    each.value["policies"]["arn"],
    each.value["ecrAccess"]["arn"],
    each.value["vpc_policie"]["arn"],
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    aws_iam_policy.CodeBuildBase-KMS-access.arn,
    aws_iam_policy.policie-repo-access.arn
  ]
  path = "/service-role/"

  tags = {

  }
}

resource "aws_iam_role" "pipeline-roles" {
  for_each = aws_iam_policy.POLICIE_PIPELINE

  name = "AWSCodePipelineServiceRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path = "/service-role/"
  managed_policy_arns = [
    each.value["arn"],
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    aws_iam_policy.policie-repo-access.arn
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
  tags = {

  }
}

resource "aws_iam_role" "pipeline-roles-kube-apply" {
  for_each = aws_iam_policy.pipeline-kube-apply-policies

  name = "AWSCodePipelineServiceRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path = "/service-role/"
  managed_policy_arns = [
    each.value["arn"],
    //TODO: Change me darle menos permisos XD
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    aws_iam_policy.policie-repo-access.arn,

  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
  tags = {

  }
}

resource "aws_iam_role" "pipeline-roles-terraform" {
  for_each = aws_iam_policy.pipeline-terraform-policies

  name = "AWSCodePipeline-${var.AWS_DEFAULT_REGION}-${each.key}"
  path = "/service-role/"
  managed_policy_arns = [
    each.value["arn"],
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    aws_iam_policy.policie-repo-access.arn,

  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
  tags = {

  }
}