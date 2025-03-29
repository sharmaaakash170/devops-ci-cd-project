pipeline {
    agent any

    environment {
        IMAGE_NAME = "sharmaaakash170/flask-app"
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

        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-id', variable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u sharmaaakash170 --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                docker tag $IMAGE_NAME $IMAGE_NAME:latest
                docker push $IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-id']) {
                    sh 'kubectl apply -f flask-app-deployment.yml --validate=false'
                    sh 'kubectl apply -f flask-app-service.yml --validate=false'
                }
            }
        }
    }
}
