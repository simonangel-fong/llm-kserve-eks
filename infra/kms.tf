# kms.tf

resource "aws_kms_key" "platform" {
  description             = "${local.name_prefix} EKS secrets and workload storage"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${local.name_prefix}-platform"
  }
}

resource "aws_kms_alias" "platform" {
  name          = "alias/${local.name_prefix}-platform"
  target_key_id = aws_kms_key.platform.key_id
}
