resource "aws_iam_role" "eks_terraform_role" {
  name               = "eks-terraform-role"
  assume_role_policy = data.aws_iam_policy_document.eks_terraform_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_terraform_assume_role_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eksctl-*"]
  }
}

resource "aws_iam_policy" "eks_terraform_policy" {
  name        = "eks-terraform-policy"
  description = "Policy for Terraform to manage EKS and Kubernetes resources"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:UpdateKubeconfig",
          "eks:ListClusters",
          "iam:ListRoles"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "k8s:Create",
          "k8s:Read",
          "k8s:Update",
          "k8s:Delete"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_terraform_policy_attachment" {
  role       = aws_iam_role.eks_terraform_role.name
  policy_arn = aws_iam_policy.eks_terraform_policy.arn
}
