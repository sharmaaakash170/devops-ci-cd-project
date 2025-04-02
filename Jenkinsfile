pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-app'
        AWS_REGION = 'us-east-1'
        ECR_REPO = '147997156416.dkr.ecr.us-east-1.amazonaws.com/flask-app'
        KUBE_CONFIG = credentials('kubeconfig')  // Store kubeconfig in Jenkins credentials
        AWS_ACCESS_KEY_ID= 
        AWS_SECRET_ACCESS_KEY= 
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

        // stage('Login to Docker Hub') {
        //     steps {
        //         withCredentials([string(credentialsId: 'docker-hub-id', variable: 'DOCKER_PASS')]) {
        //             sh 'echo $DOCKER_PASS | docker login -u sharmaaakash170 --password-stdin'
        //         }
        //     }
        // }
        
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
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG'),
                                string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                                string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    export KUBECONFIG=/tmp/kubeconfig
                    aws eks update-kubeconfig --region us-east-1 --name flask-cluster --kubeconfig /tmp/kubeconfig
                    aws sts get-caller-identity  # Check if AWS credentials are working
                    kubectl get nodes
                    kubectl set image deployment/flask flask-app=$ECR_REPO:latest --namespace default
                    kubectl rollout restart deployment flask -n default
                    '''
                }
            }
        }

        // stage('Push to Docker Hub') {
        //     steps {
        //         sh '''
        //         docker tag $IMAGE_NAME $IMAGE_NAME:latest
        //         docker push $IMAGE_NAME:latest
        //         '''
        //     }
        // }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         withKubeConfig([credentialsId: 'kubeconfig-id']) {
        //             sh 'kubectl apply -f flask-app-deployment.yml --validate=false'
        //             sh 'kubectl apply -f flask-app-service.yml --validate=false'
        //         }
        //     }
        // }
    }
}



