pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/SyedYakhub/ecommerce-app.git'
        DOCKER_IMAGE = 'yakhub4881/app-ecommerce'
        TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: "${GITHUB_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    // sh "docker tag ${DOCKER_IMAGE}:${TAG} ${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_IMAGE}:${TAG}"
                }
            }
        }

        stage('Deploy to k3s') {
            steps {
                sshagent(['ec2-user']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@13.126.135.30 kubectl apply -f ecommerce-app-deployment.yml 'sh 'ssh -o StrictHostKeyChecking=no root@192.5.101.8 sudo docker-compose -f /root/git/docker-compose.yaml up -d'
                    }
                }
            }
        
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}