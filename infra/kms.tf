# kms.tf

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "platform_kms" {
  statement {
    sid       = "EnableIAMPermissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    actions = [
      "kms:Decrypt*",
      "kms:Describe*",
      "kms:Encrypt*",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${local.aws_region}.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:${data.aws_partition.current.partition}:logs:${local.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/${local.eks_cluster_name}/cluster"
      ]
    }
  }
}

resource "aws_kms_key" "platform" {
  description             = "${local.name_prefix} EKS secrets and workload storage"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.platform_kms.json

  tags = {
    Name = "${local.name_prefix}-platform"
  }
}

resource "aws_kms_alias" "platform" {
  name          = "alias/${local.name_prefix}-platform"
  target_key_id = aws_kms_key.platform.key_id
}
