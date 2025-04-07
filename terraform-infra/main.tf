module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "flask-app-vpc"
}

module "subnet" {
  source = "./subnet"

  vpc_id = module.vpc.vpc_id
  subnet_name = "flask-app"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_azs           = ["us-east-1a", "us-east-1b"]

  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  private_azs          = ["us-east-1a", "us-east-1b"]
}

module "igw" {
  source = "./igw"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.subnet.public_subnet_ids[0]
}

module "nat_gateway" {
  source = "./nat-gateway"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.subnet.public_subnet_ids[0]   
  private_subnet_id = module.subnet.private_subnet_ids[0]
}

module "security_group" {
  source = "./security-groups"
  vpc_id = module.vpc.vpc_id
}

# module "ec2" {
#   source = "./ec2"
#   subnet_id = module.subnet.public_subnet_ids[0] 
#   vpc_security_group_ids = [module.security_group.jenkins_sg_id]
#   eks_admin_profile = aws_iam_instance_profile.eks_admin_profile.name
# }

module "eks_cluster" {
  source = "./eks-cluster"
  private_subnet_ids = module.subnet.private_subnet_ids
}

module "eks_node_cluster" {
  source = "./eks-node-group"
  node_private_subnet_ids = [ module.subnet.private_subnet_ids[0] ]
  cluster_name = module.eks_cluster.cluster_name
}

module "gp2" {
  source = "./gp2"
  cluster_ca_certificate = module.eks_cluster.cluster_ca_certificate
  cluster_endpoint       = module.eks_cluster.endpoint
  token                  = module.eks_cluster.token
}

module "ecr" {
  source = "./ecr"
  repository_name = "flask-app"
}

module "codebuild" {
  source             = "./codeBuild"
  project_name       = "flask-app"
  ecr_repo_url       = module.ecr.repository_url
  aws_account_id = "891062950211"
  aws_region = var.aws_region
}

module "codepipeline" {
  source                 = "./codepipeline"
  project_name           = "flask-app"
  env                    = "dev"
  region                 = var.aws_region
  codebuild_project_name = module.codebuild.codebuild_project_name
  github_repo            = "devops-ci-cd-project"
  github_owner           = "sharmaaakash170"
  github_branch          = "main"
  github_oauth_token     = var.github_oauth_token # store securely
}

module "helm_charts" {
  source       = "./helm-charts"
  app_name     = "flask-app"
  namespace    = "flask"
  chart_path   = "../flask-app/"       # Path to your chart
  values_file  = "../flask-app/values.yaml"
}

