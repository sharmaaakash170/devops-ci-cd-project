pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-app'
        AWS_REGION = 'us-east-1'
        ECR_REPO = '147997156416.dkr.ecr.us-east-1.amazonaws.com/flask-app'
        KUBE_CONFIG = credentials('kubeconfig')  // Store kubeconfig in Jenkins credentials
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/sharmaaakash170/devops-ci-cd-project.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                docker tag flask-app:latest $ECR_REPO:latest
                docker push $ECR_REPO:latest
                '''
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh '''
                kubectl get nodes
                kubectl set image deployment/flask flask-app=$ECR_REPO:latest --namespace default
                kubectl rollout restart deployment flask -n default
                '''
            }
        }
    }
        
}