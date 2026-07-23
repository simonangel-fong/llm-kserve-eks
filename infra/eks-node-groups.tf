# eks-node-groups.tf

resource "aws_launch_template" "general" {
  name_prefix            = "${local.name_prefix}-general-"
  description            = "EKS general node group with encrypted gp3 root storage"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.platform.arn
      volume_size           = 50
      volume_type           = "gp3"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.default_tags, {
      Name = "${local.name_prefix}-general-node"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(local.default_tags, {
      Name = "${local.name_prefix}-general-node"
    })
  }
}

resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.name_prefix}-general"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = [for subnet in aws_subnet.private : subnet.id]
  version         = local.eks_version
  ami_type        = "AL2023_x86_64_STANDARD"
  capacity_type   = "ON_DEMAND"
  instance_types  = local.eks_cpu_node_instance_types

  launch_template {
    id      = aws_launch_template.general.id
    version = aws_launch_template.general.latest_version
  }

  labels = {
    workload = "general"
  }

  scaling_config {
    min_size     = local.eks_cpu_node_min
    desired_size = local.eks_cpu_node_desired
    max_size     = local.eks_cpu_node_max
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_eks_addon.vpc_cni,
    aws_iam_role_policy_attachment.eks_node_ecr,
    aws_iam_role_policy_attachment.eks_node_worker,
    aws_kms_key.platform,
  ]
}
