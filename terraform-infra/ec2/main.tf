# resource "aws_key_pair" "jenkins_key" {
#   key_name   = "jenkins_key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

# resource "aws_instance" "jenkins_instance" {
#   ami = var.ami
#   instance_type = var.instance_type
#   subnet_id = var.subnet_id
#   key_name = aws_key_pair.jenkins_key.key_name
#   associate_public_ip_address = true
#   iam_instance_profile = var.eks_admin_profile

#   vpc_security_group_ids = var.vpc_security_group_ids

#   tags = {
#     Name = "jenkins-ec2"
#   }
# }