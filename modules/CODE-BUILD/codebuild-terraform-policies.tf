#--------------------------
# Políticas de codebuild para terraform
#---------------------------
resource "aws_iam_policy" "vpc-policy-terraform" {

  name        = "CodeBuildVpcPolicy-terraform-${var.AWS_DEFAULT_REGION}"
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
              "arn:aws:ec2:*"
            ],
            "ec2:AuthorizedService" : "codebuild.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "*"
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

resource "aws_iam_policy" "code-build-based-policy-terraform" {


  tags        = {}
  tags_all    = {}
  name        = "CodeBuildBasePolicy-terraform-${var.AWS_DEFAULT_REGION}"
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
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/*",
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*:log-stream:*"
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
          "*"
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
          "arn:aws:codebuild:us-east-1:${var.AWS_ACCOUNT_ID}:report-group/*"
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
      {
        "Action": [
          "codestar-connections:UseConnection",
          "codestar-connections:*"
        ],
        "Resource": "*",
        "Effect": "Allow"
      },
      {
        "Action": [
          "codebuild:BatchGetProjects"
        ],
        "Resource": "*",
        "Effect": "Allow"
      }
    ]
  })


}