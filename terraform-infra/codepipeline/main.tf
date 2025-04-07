data "aws_caller_identity" "current" {}

resource "random_id" "bucket_id" {
  byte_length = 4
}

data "aws_ssm_parameter" "github_token" {   
  name = "github_token"
  with_decryption = true
}

resource "aws_codepipeline_webhook" "github_webhook" {
  name            = "github-webhook"
  target_pipeline = aws_codepipeline.flask_pipeline.name
  target_action   = "Source"
  authentication  = "GITHUB_HMAC"

  authentication_configuration {
    secret_token = data.aws_ssm_parameter.github_token.value
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/main"
  }
}



resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "codepipeline-${var.region}-${var.project_name}-${data.aws_caller_identity.current.account_id}-${random_id.bucket_id.hex}"
  force_destroy = true

  tags = {
    Name        = "CodePipeline Artifact Bucket"
    Environment = var.project_name
  }
}

resource "aws_codepipeline" "flask_pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken =  data.aws_ssm_parameter.github_token.value
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.project_name}-codebuild"
      }
    }
  }

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_full_access" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_access" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_power_user" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_full_access" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_logs_access" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy" "codepipeline_s3_access" {
  name = "codepipeline-s3-access"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
        #   "s3:GetObject",
        #   "s3:PutObject",
        #   "s3:PutObjectAcl",
        #   "s3:GetBucketLocation"
            "s3:*"
        ],
        Resource = [
          "*",
        #   "${aws_s3_bucket.codepipeline_bucket.arn}",
        #   "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_logging" {
  name = "codebuild-logging"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
        #   "logs:CreateLogGroup",
        #   "logs:CreateLogStream",
        #   "logs:PutLogEvents"
          "logs:*"
        ],
        Resource = [
          "*"
        #   "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_codebuild_access" {
  name = "codepipeline-codebuild-access"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
        #   "codebuild:BatchGetBuilds",
        #   "codebuild:StartBuild",
          "codebuild:*"
        ],
        Resource = "*"
        # Resource = "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:project/${var.project_name}-codebuild"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_ecr_access" {
  name = "codebuild-ecr-access"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:*"
        ],
        Resource = "*"
      }
    ]
  })
}

