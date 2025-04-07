output "aws_security_group" {
  value = aws_security_group.flask_eks_node_sg.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}