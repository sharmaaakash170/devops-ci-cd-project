pipeline {
    agent any

    environment {
        IMAGE_NAME = "sharmaaakash170/flask-app"
    }

    stages{
        stage('Clone Repo') {
            steps{
                git 'https://github.com/sharmaaakash170/devops-ci-cd-project.git'
            }
        }

        stage('Build Docker Image') {
            steps{
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


        stage('Push to Docker Hub'){
            steps{
                sh '''
                docker tag $IMAGE_NAME $IMAGE_NAME:latest
                docker push $IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy Container'){
            steps{
                sh '''
                docker stop flask-container || true
                docker rm flask-container || true
                docker run -d --name flask-container -p 5000:5000 $IMAGE_NAME:latest
                '''
            }
        }
    }
}
