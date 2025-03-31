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
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG
                    kubectl set image deployment/flask flask-app=$ECR_REPO:latest --namespace default
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


