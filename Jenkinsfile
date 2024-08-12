pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/SyedYakhub/ecommerce-app.git'
        DOCKER_IMAGE = 'yakhub4881/app-ecommerce'
        K3S_SERVER_IP = '13.126.135.30'
        TAG = 'latest'
        DOCKER_PASSWORD = 'Cj@kif9966' 
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
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u yakhub4881 --password-stdin"
                    sh "docker tag ${DOCKER_IMAGE}:${TAG} ${DOCKER_IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_IMAGE}:${TAG}"
                }
            }
        }

        stage('Deploy to k3s') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'k3s-Server', usernameVariable: 'K3S_USERNAME', keyFileVariable: 'K3S_KEY')]) {
                    script {
                        sh """
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${K3S_USERNAME}@${K3S_SERVER_IP} "kubectl apply -f ecommerce-app-deployment.yml"
                        """
                    }
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