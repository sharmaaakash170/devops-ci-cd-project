variable "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Base64 encoded CA cert of the EKS cluster"
  type        = string
}

variable "token" {
  description = "Authentication token for Kubernetes"
  type        = string
}
