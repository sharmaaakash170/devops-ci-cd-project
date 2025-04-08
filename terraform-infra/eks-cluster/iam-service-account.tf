# resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
#   url = "https://oidc.eks.${var.region}.amazonaws.com/id/${aws_eks_cluster.flask_cluster.identity[0].oidc[0].issuer}"
  
#   client_id_list = ["sts.amazonaws.com"]  # Standard client ID for EKS OIDC
  
#   thumbprint_list = [data.tls_certificate.eks_oidc_thumbprint.certificates[0].sha1_fingerprint]
# }
# # Required data source to get the thumbprint
# data "tls_certificate" "eks_oidc_thumbprint" {
#   url = aws_eks_cluster.flask_cluster.identity[0].oidc[0].issuer
# }
# resource "aws_iam_role" "eks_service_account_role" {
#   name               = "eks-service-account-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action    = "sts:AssumeRoleWithWebIdentity"
#         Principal = {
#           Federated = aws_iam_oidc_provider.eks_oidc_provider.arn
#         }
#         Effect    = "Allow"
#         Condition = {
#           StringEquals = {
#             "${aws_eks_cluster.flask_cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "eks_service_account_policy" {
#   name        = "eks-service-account-policy"
#   description = "Permissions for the service account to access EKS resources"
#   policy      = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "eks:DescribeCluster",
#           "eks:ListClusters",
#           "iam:ListRoles",
#           "iam:ListRolePolicies"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#       {
#         Action = [
#           "k8s:Create",
#           "k8s:Read",
#           "k8s:Update",
#           "k8s:Delete"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_service_account_policy_attachment" {
#   role       = aws_iam_role.eks_service_account_role.name
#   policy_arn = aws_iam_policy.eks_service_account_policy.arn
# }
