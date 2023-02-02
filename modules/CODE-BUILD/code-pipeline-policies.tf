resource "aws_iam_policy" "POLICIE_PIPELINE" {
  for_each = {
  for compilation in var.compilations :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "AWSCodePipelineServiceRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = file("${path.module}/pipeline-policie.json")
}

resource "aws_iam_policy" "pipeline-kube-apply-policies" {
  for_each = {
  for compilation in var.back-kube-apply :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "AWSCodePipelineServiceRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = file("${path.module}/pipeline-policie.json")
}

resource "aws_iam_policy" "pipeline-terraform-policies" {
  for_each = {
  for compilation in var.terraform-services :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "PipelineRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline for terraform pipelines"

  policy = file("${path.module}/pipeline-policie.json")
}


#--------------------------
# Permite asumir un rol de la cuenta donde están los repos
# Intended for other environment accounts
#---------------------------
resource "aws_iam_policy" "policie-repo-access" {

  tags        = {}
  tags_all    = {}
  name        = "policie-allow-repo-access"
  path        = "/service-role/"
  description = "Permite asumir un rol de la cuenta donde están los repos"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect   = "Allow"
        Resource = [
          //TODO :PARAMETRIZAR
          "arn:aws:iam::798152040102:role/*",
          "arn:aws:iam::003297768880:role/*"
        ]
      },
      {
        "Sid": "EKSREADONLY",
        "Effect": "Allow",
        "Action": [
          "eks:DescribeNodegroup",
          "eks:DescribeUpdate",
          "eks:DescribeCluster"
        ],
        "Resource": "*"
      }
    ]
  })
}


data aws_iam_policy ec2fullaccess {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy" "POLICIE_VPC" {
  for_each = {
  for compilation in var.compilations :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildVpcPolicy-${each.key}-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterfacePermission",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [

          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Resource = [
          "arn:aws:ec2:us-east-1:us-east-1:network-interface/*",
        ]
        Effect    = "Allow"
        Condition = {
          StringEquals = {

            "ec2:Subnet" = [
              "arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[0]}",
              "arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[1]}"
              //"arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[2]}",
              //"arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[3]}"
            ],
            "ec2:AuthorizedService" : "codebuild.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:codecommit:us-east-1:${var.AWS_ACCOUNT_ID}:${each.key}"
        ],
        "Action" : [
          "codecommit:GitPull"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Action" : [
          "codepipeline:StartPipelineExecution"
        ]
      }

    ]
  })


}

resource "aws_iam_policy" "vpc-policy-kube-apply" {
  for_each = {
  for compilation in var.back-kube-apply :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildVpcPolicy-${each.key}-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterfacePermission",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [

          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Resource = [
          "arn:aws:ec2:us-east-1:us-east-1:network-interface/*",
        ]
        Effect    = "Allow"
        Condition = {
          StringEquals = {

            "ec2:Subnet" = [
              "arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[0]}",
              "arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[1]}"
              //"arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[2]}",
              //"arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[3]}"
            ],
            "ec2:AuthorizedService" : "codebuild.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:codecommit:us-east-1:${var.AWS_ACCOUNT_ID}:${each.key}"
        ],
        "Action" : [
          "codecommit:GitPull"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Action" : [
          "codepipeline:StartPipelineExecution"
        ]
      }

    ]
  })


}

resource "aws_iam_policy" "CodeBuildBasePolicy" {
  for_each = {
  for compilation in var.compilations :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildBasePolicy-${each.key}-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}",
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}:*",
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*:log-stream:*"
          //"${aws_s3_bucket.omnia-s3-log-bucket.arn}"
        ]
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
          //"arn:aws:s3:::codepipeline-${var.AWS_DEFAULT_REGION}-*",
          aws_s3_bucket.omnia-s3-log-bucket.arn,
          "${aws_s3_bucket.omnia-s3-log-bucket.arn}/*"

        ]
      },
      {
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*",
          "arn:aws:codebuild:us-east-1:${var.AWS_ACCOUNT_ID}:report-group/${each.key}-*"
        ]
      },
      {
        Action = [
          "codeartifact:ReadFromRepository",
          "codeartifact:GetAuthorizationToken",
          "sts:GetServiceBearerToken"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "ssm:PutParameter"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket.omnia-s3-log-bucket]
}

resource "aws_iam_policy" "CodeBuildBasePolicyKubeApply" {
  for_each = {
  for compilation in var.back-kube-apply :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildBasePolicy-${each.key}-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}",
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}:*",
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*:log-stream:*"
          //"${aws_s3_bucket.omnia-s3-log-bucket.arn}"
        ]
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
          //"arn:aws:s3:::codepipeline-${var.AWS_DEFAULT_REGION}-*",
          aws_s3_bucket.omnia-s3-log-bucket.arn,
          "${aws_s3_bucket.omnia-s3-log-bucket.arn}/*"

        ]
      },
      {
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*",
          "arn:aws:codebuild:us-east-1:${var.AWS_ACCOUNT_ID}:report-group/${each.key}-*"
        ]
      },
      {
        Action = [
          "codeartifact:ReadFromRepository",
          "codeartifact:GetAuthorizationToken",
          "sts:GetServiceBearerToken"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "ssm:PutParameter"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      },

    ]
  })

  depends_on = [aws_s3_bucket.omnia-s3-log-bucket]
}

resource "aws_iam_policy" "CodeBuildBase-KMS-access" {

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildBasePolicy-kms-interaccount-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:*"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })
}


