resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "codebuild_full_access_policy" {
  name = "codebuild-full-access-policy"
  role = aws_iam_role.codebuild_service_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "Statement1",
        Effect: "Allow",
        Action: [
          "ec2:*",
          "codepipeline:*",
          "eks:*",
          "eks-auth:*",
          "iam:*",
          "s3:*",
          "cloudwatch:*",
          "codebuild:*",
          "ecr:*",
          "logs:*"
        ],
        Resource: ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_power_user" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_codebuild_project" "flask_app" {
  name         = "${var.project_name}-codebuild"
  description  = "Build project for Flask app"
  service_role = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ECR_REPO_URL"
      value = var.ecr_repo_url
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/sharmaaakash170/devops-ci-cd-project"
    buildspec = "buildspec.yml"
  }

  tags = {
    Project = var.project_name
  }
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_service_role.arn
}
