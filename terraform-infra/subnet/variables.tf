variable "vpc_id" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "public_azs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "private_azs" {
  type = list(string)
}
