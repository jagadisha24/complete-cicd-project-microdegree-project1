pipeline {
    agent any

    environment {
        DOCKER_TAG = "20241003"
        IMAGE_NAME = "jagadishasiddaiah/fullstack"
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "microdegree-cluster"
    }

    tools {
        jdk 'java-17'
        maven 'maven'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/jagadisha24/complete-cicd-project-microdegree-project1.git'
            }
        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Build') {
            steps {
                sh "mvn package"
            }
        }

        stage('Build & Tag Docker Image') {
            steps {
                script {
                    sh "sudo docker build -t ${IMAGE_NAME}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Docker Image Scan') {
            steps {
                script {
                    sh "trivy image --format table -o trivy-image-report.html ${IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }
        
        stage('Updating the Cluster') {
            steps {
                script {
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}"
                }
            }
        }
        
        stage('Deploy To Kubernetes') {
            steps {
                script {
                    withKubeConfig(
                        caCertificate: '', 
                        clusterName: 'microdegree-cluster', 
                        contextName: '', 
                        credentialsId: 'kube', 
                        namespace: 'microdegree', 
                        restrictKubeConfigAccess: false, 
                        serverUrl: 'https://9E109175FB941EB8A2EF1F59797AC03B.gr7.ap-south-1.eks.amazonaws.com'
                    ) { 
                        sh "kubectl get pods -n microdegree"
                        sh "kubectl apply -f deployment.yml -n microdegree"
                    }
                }
            }
        }

        stage('Verify the Deployment') {
            steps {
                script {
                    withKubeConfig(
                        caCertificate: '', 
                        clusterName: 'microdegree-cluster', 
                        contextName: '', 
                        credentialsId: 'kube', 
                        namespace: 'microdegree', 
                        restrictKubeConfigAccess: false, 
                        serverUrl: 'https://9E109175FB941EB8A2EF1F59797AC03B.gr7.ap-south-1.eks.amazonaws.com'
                    ) { 
                        sh "kubectl get pods -n microdegree"
                        sh "kubectl get svc -n microdegree"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'

                def body = """
                    <html>
                    <body>
                    <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                    <h2>${jobName} - Build ${buildNumber}</h2>
                    <div style="background-color: ${bannerColor}; padding: 10px;">
                    <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                    </div>
                    <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                    </div>
                    </body>
                    </html>
                """

                emailext (
                    subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                    body: body,
                    to: 'jagadeeshsiddayya@gmail.com',
                    from: 'jagdishsiddaiah2408@gmail.com',
                    replyTo: 'jagdishsiddaiah2408@gmail.com',
                    mimeType: 'text/html',
                    attachmentsPattern: 'trivy-image-report.html'
                )
            }
        }
    }
}
