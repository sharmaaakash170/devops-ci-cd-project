variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "addon_version" {
  description = "Addon version (optional)"
  type        = string
  default     = "v1.29.1-eksbuild.1"
}
