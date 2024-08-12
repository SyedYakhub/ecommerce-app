pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/SyedYakhub/ecommerce-app.git'
        DOCKER_IMAGE = 'yakhub4881/app-ecommerce'
        K3S_SERVER_IP = '13.126.135.30'
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
                withCredentials([usernameColonPassword(credentialsId: 'dockerhub', variable: 'dockerHubCreds')]) {
                    script {
                        def DOCKER_USERNAME = dockerHubCreds.username
                        def DOCKER_PASSWORD = dockerHubCreds.password
                        docker.withRegistry('https://index.docker.io/', "${DOCKER_USERNAME}:${DOCKER_PASSWORD}") {
                            def dockerImage = docker.image("${DOCKER_IMAGE}:latest")
                            dockerImage.push('latest')
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


// pipeline {
//     agent any

//     stages {
//         stage('Test Docker Credentials') {
//             steps {
//                 withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
//                     script {
//                         echo "Docker Username: ${DOCKER_USERNAME}"
//                         echo "Docker Password: ${DOCKER_PASSWORD}"
//                     }
//                 }
//             }
//         }
//     }
// }
