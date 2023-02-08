#--------------------------
# Políticas de codebuild para terraform
#---------------------------
resource "aws_iam_role" "terraform-role" {
  name = "codebuild-terraform-service-role"
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

    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator",
    aws_iam_policy.code-build-based-policy-terraform.arn,
    aws_iam_policy.vpc-policy-terraform.arn
  ]
  path = "/service-role/"

  tags = {

  }
}