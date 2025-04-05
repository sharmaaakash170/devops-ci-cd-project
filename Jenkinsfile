pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-app'
        AWS_REGION = 'us-east-1'
        TAG = 'latest'
        ECR_REPO = '147997156416.dkr.ecr.us-east-1.amazonaws.com/flask-app'
        HELM_RELEASE = 'flask-app-release'
        HELM_CHART_PATH = 'flask-app'
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
                    helm repo add stable https://charts.helm.sh/stable
                    helm repo update
                    helm upgrade --install $HELM_RELEASE $HELM_CHART_PATH --namespace default --set image.repository=$ECR_REPO --set image.tag=$TAG
                    '''
                    
                }
            }
        }
    }
}


/*
                    ===============For Helm Deployment============================
                    
                    helm repo add stable https://charts.helm.sh/stable
                    helm repo update
                    helm upgrade --install $HELM_RELEASE $HELM_CHART_PATH --namespace default --set image.repository=$ECR_REPO --set image.tag=$TAG

                    
                    ====================For Kubeclt deployment=============================

                    kubectl apply -f flask-app-deployment.yml || echo "Deployment already exists"
                    kubectl apply -f flask-app-service.yml || echo "Service already exists"
                    kubectl set image deployment/flask-app flask-app=$ECR_REPO:latest
                    kubectl rollout restart deployment flask-app
*/