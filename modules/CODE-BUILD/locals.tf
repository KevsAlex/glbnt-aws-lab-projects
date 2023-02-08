locals {

  SOURCE = "Source"
  BUILD = "Build"
  DEPLOY = "Deploy"

  BUIL_SPECT = "buildspec.yml"

  compilation-policies = [
  for compilation in var.compilations: {
    policies = [
      lookup(
        {for key, value in aws_iam_policy.CodeBuildBasePolicy:  key => value},
        compilation.name,
        "what?")

    ][0]
    ecrAccess = data.aws_iam_policy.ec2fullaccess
    vpc_policie = [
      lookup(
        {for key, value in aws_iam_policy.POLICIE_VPC:  key => value},
        compilation.name,
        "what?")

    ][0]
    name = compilation.name
  }
  ]

  compilation-policies-kube-apply = [
  for compilation in var.back-kube-apply: {
    policies = [
      lookup(
        {for key, value in aws_iam_policy.CodeBuildBasePolicyKubeApply:  key => value},
        compilation.name,
        "what?")

    ][0]
    ecrAccess = data.aws_iam_policy.ec2fullaccess
    vpc_policie = [
      lookup(
        {for key, value in aws_iam_policy.vpc-policy-kube-apply:  key => value},
        compilation.name,
        "what?")

    ][0]
    name = compilation.name
  }
  ]

  //pipeline-policies = {for key, value in aws_iam_policy.POLICIE_PIPELINE:  key => value["arn"]}
  kms-keys = [
  for compilation in var.compilations: {
    name = compilation.name
  }
  ]




}