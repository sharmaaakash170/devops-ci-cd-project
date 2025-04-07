output "jenkins" {
  value = aws_instance.jenkins_instance.public_ip
}