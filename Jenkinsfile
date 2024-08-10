pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/SyedYakhub/ecommerce-app.git'
        DOCKER_IMAGE = 'yakhub4881/app-ecommerce'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: "${GITHUB_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        docker.withRegistry('', "${DOCKER_USERNAME}:${DOCKER_PASSWORD}") {
                            docker.image("${DOCKER_IMAGE}:latest").push()
                        }
                    }
                }
            }
        }

        stage('Deploy to k3s') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'kubeconfig-file', keyFileVariable: 'KUBECONFIG_FILE', usernameVariable: 'KUBECONFIG_USERNAME')]) {
                    script {
                        sh """
                        export KUBECONFIG=${KUBECONFIG_FILE}
                        kubectl apply -f ecommerce-app-deployment.yml
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


