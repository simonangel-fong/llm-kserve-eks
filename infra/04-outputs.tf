# outputs.tf

output "vpc_id" {
  description = "ID of the VPC used by EKS."
  value       = aws_vpc.this.id
}

output "availability_zones" {
  description = "Availability Zones used by the network layer."
  value       = local.availability_zones
}

output "public_subnet_ids" {
  description = "IDs of the public subnets used for NAT and future public load balancers."
  value       = [for index in range(local.vpc_az_count) : aws_subnet.public[index].id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets reserved for EKS worker nodes."
  value       = [for index in range(local.vpc_az_count) : aws_subnet.private[index].id]
}

output "nat_gateway_id" {
  description = "ID of the single dev NAT Gateway."
  value       = aws_nat_gateway.this.id
}

output "platform_kms_key_arn" {
  description = "ARN of the customer-managed KMS key for EKS secrets and workload storage."
  value       = aws_kms_key.platform.arn
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS control-plane IAM role."
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS managed-node-group IAM role."
  value       = aws_iam_role.eks_node.arn
}

output "vpc_cni_pod_identity_role_arn" {
  description = "ARN of the VPC CNI EKS Pod Identity role."
  value       = aws_iam_role.vpc_cni.arn
}

output "ebs_csi_pod_identity_role_arn" {
  description = "ARN of the EBS CSI EKS Pod Identity role."
  value       = aws_iam_role.ebs_csi.arn
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS Kubernetes API."
  value       = aws_eks_cluster.this.endpoint
}

output "eks_cluster_security_group_id" {
  description = "ID of the security group created by EKS for the cluster."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "eks_administrator_principal_arn" {
  description = "IAM principal granted cluster-administrator access through an EKS access entry."
  value       = aws_eks_access_entry.administrator.principal_arn
}

output "eks_pod_identity_agent_version" {
  description = "Pinned EKS Pod Identity Agent add-on version selected for this cluster."
  value       = aws_eks_addon.pod_identity_agent.addon_version
}

output "eks_vpc_cni_version" {
  description = "Pinned VPC CNI add-on version selected for this cluster."
  value       = aws_eks_addon.vpc_cni.addon_version
}

output "eks_general_node_group_name" {
  description = "Name of the general-purpose EKS managed node group."
  value       = aws_eks_node_group.general.node_group_name
}
