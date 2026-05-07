data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "vpc" {
  source              = "../../modules/vpc"
  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  public_subnet_azs   = var.public_subnet_azs
  tags                = local.tags
}

module "security_groups" {
  source            = "../../modules/security-groups"
  name_prefix       = local.name_prefix
  vpc_id            = module.vpc.vpc_id
  dev_ingress_cidrs = var.dev_ingress_cidrs
  tags              = local.tags
}

module "dev_ec2" {
  source            = "../../modules/dev-ec2"
  name_prefix       = local.name_prefix
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_groups.dev_ec2_security_group_id
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  tags              = local.tags
}

resource "aws_ecr_repository" "this" {
  for_each             = toset(["chefmind-backend", "chefmind-web", "chefmind-litellm"])
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_iam_user" "github_actions" {
  name = "chefmind-github-actions"
}

resource "aws_iam_user_policy" "github_actions_core" {
  name = "chefmind-github-actions-inline"
  user = aws_iam_user.github_actions.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "ECRPushPull"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = [
          for name in ["chefmind-backend", "chefmind-web", "chefmind-litellm"] :
          "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${name}"
        ]
      },
      {
        Sid    = "SSMSendCommand"
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:ssm:${var.aws_region}::document/AWS-RunShellScript",
          "arn:${data.aws_partition.current.partition}:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/${module.dev_ec2.instance_id}"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy" "github_actions_ecr" {
  name = "chefmind-github-actions-ecr-inline"
  user = aws_iam_user.github_actions.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:DescribeRepositories",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy" "github_actions_describe_repositories" {
  name = "chefmind-github-actions-describe-repos-inline"
  user = aws_iam_user.github_actions.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ecr:DescribeRepositories"
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy" "github_actions_ssm_read_sts" {
  name = "chefmind-github-actions-ssm-read-sts-inline"
  user = aws_iam_user.github_actions.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "SSMReadAndSTSPreflight"
      Effect = "Allow"
      Action = [
        "ssm:ListCommandInvocations",
        "ssm:ListCommands",
        "ssm:DescribeInstanceInformation",
        "sts:GetCallerIdentity"
      ]
      Resource = "*"
    }]
  })
}
