pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-app'
        AWS_REGION = 'us-east-1'
        ECR_REPO = '147997156416.dkr.ecr.us-east-1.amazonaws.com/flask-app'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/sharmaaakash170/devops-ci-cd-project.git'
            }
        }

        stage('Build and Push Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME .
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                docker tag $IMAGE_NAME:latest $ECR_REPO:latest
                docker push $ECR_REPO:latest
                '''
            }
        }
        stage('Deploy to EKS') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG
                    
                    kubectl apply -f flask-app-deployment.yml || echo "Deployment already exists"
                    
                    kubectl apply -f flask-app-service.yml || echo "Service already exists"

                    kubectl set image deployment/flask-app flask-app=$ECR_REPO:latest
                    kubectl rollout restart deployment flask-app
                    '''
                }
            }
        }
    }
}
