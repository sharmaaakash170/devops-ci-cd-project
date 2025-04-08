variable "cluster_name" {
    default = "flask-eks-cluster"
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "region" {
  type = string
}
