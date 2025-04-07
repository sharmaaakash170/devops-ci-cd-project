# =========== EKS GROUP AND ITS RULES======================================

resource "aws_security_group" "flask_eks_node_sg" {
  name = "flask-eks-nodes-eg"
  description = "Allow traffic for EKS Worker Node"
  vpc_id = var.vpc_id 
  tags = {
    Name = "flask-eks-nodes-eg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.flask_eks_node_sg.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.flask_eks_node_sg.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_flask_app" {
  security_group_id = aws_security_group.flask_eks_node_sg.id
  ip_protocol = "tcp"
  from_port = 5000
  to_port = 5000
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.flask_eks_node_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


# ================ EC2 JENKINS GROUP AND ITS RULES======================

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-security-group"
  description = "Allow traffic for Jenkins"
  vpc_id = var.vpc_id
  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_jenkins" {
  security_group_id = aws_security_group.jenkins_sg.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_jenkins" {
  security_group_id = aws_security_group.jenkins_sg.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins_portal" {
  security_group_id = aws_security_group.jenkins_sg.id
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_jenkins" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}