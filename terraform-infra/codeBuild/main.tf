resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_service_role.arn
}


resource "aws_codebuild_project" "flask_app" {
  name          = "${var.project_name}-codebuild"
  description   = "Build project for Flask app"
  service_role  = aws_iam_role.codebuild_service_role.arn

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
}

  source {
    type      = "GITHUB"
    location  = "https://github.com/sharmaaakash170/devops-ci-cd-project"
    buildspec = "buildspec.yml"
  }

  tags = {
    Project     = var.project_name
  }
}
