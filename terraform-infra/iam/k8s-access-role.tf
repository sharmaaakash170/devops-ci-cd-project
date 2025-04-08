resource "aws_iam_role" "eks_k8s_access_role" {
  name               = "eks-k8s-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "eks_k8s_access_policy" {
  name        = "eks-k8s-access-policy"
  role        = aws_iam_role.eks_k8s_access_role.id
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "iam:ListRoles",
          "iam:ListRolePolicies"
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
