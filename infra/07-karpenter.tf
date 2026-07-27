# 07-karpenter.tf

# ##############################
# IAM / SQS
# ##############################
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 21.0"

  cluster_name = module.eks.cluster_name

  # enable Pod Identity
  create_pod_identity_association = true
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = "${local.prefix_name}-karpenter-node"

  # enable SSM
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
