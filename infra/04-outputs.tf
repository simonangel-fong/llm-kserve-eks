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
