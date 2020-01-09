
# current region
data "aws_region" "current" {}

locals {
  alias_region  = substr(data.aws_region.current.name, 0, 2) == "cn" ? ".cn" : ""
  alias_service = "amazonaws.com${local.alias_region}"
}

# spinnaker managed
resource "aws_iam_role" "spinnaker-managed" {
  name               = local.name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.spinnaker-managed-trusted.json
}

data "aws_iam_policy_document" "spinnaker-managed-trusted" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.trusted_role_arn
    }

    principals {
      type = "Service"

      identifiers = [
        "ecs.${local.alias_service}",
        "ecs-tasks.${local.alias_service}",
        "application-autoscaling.${local.alias_service}",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ec2-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ecs-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ecs-task-exec" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "secret-manager" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "lambda-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ecr-read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "cfn-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "iam-read" {
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

# base iam intance-profile
resource "aws_iam_role" "base-iam" {
  name               = "BaseIAMRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.base-iam-trusted.json
}

data "aws_iam_policy_document" "base-iam-trusted" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ec2.${local.alias_service}",
        "ecs-tasks.${local.alias_service}",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_instance_profile" "base-iam" {
  name = "BaseIAMRole"
  role = aws_iam_role.base-iam.name
}
