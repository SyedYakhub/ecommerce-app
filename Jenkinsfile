pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/SyedYakhub/ecommerce-app.git'
        DOCKER_IMAGE = 'yakhub4881/app-ecommerce'
        K3S_SERVER_IP = '13.126.135.30'
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
                    script {
                        docker.withRegistry('https://registry.hub.docker.com/', [credentialsId: 'dockerhub']) {
                            def dockerImage = docker.image("${DOCKER_IMAGE}:${TAG}")
                            dockerImage.push()
                        }
                    }
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