output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "token" {
  value = data.aws_eks_cluster_auth.this.token
}

output "cluster_id" {
  value = data.aws_eks_cluster.this.id
}

output "cluster_id_2" {
  value = data.aws_eks_cluster.this.id
}