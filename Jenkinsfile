pipeline {
    agent any
    
    tools {
        maven 'maven'
    }
    
    environment {
        repository = imyujinsim/edu-mas-ui
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        dockerImage = '' 
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: 'github',
                    url: 'https://github.com/imyujinsim/kpaas-ui.git'
            }
        }
        
        stage('Build JAR with Maven') {
            steps {
                script {
                    try {
                        sh 'mvn clean install'
                        sh 'mv target/*.war target/${env.JOB_NAME}.war'
                    } catch(error) {
                        print('error')
                        sh "rm -rf /var/lib/jenkins/workspace/*"
                    }
                }
            }
        }
        
        stage('Make Docker Image and Push') {
            steps {
                sh """
                cat > Dockerfile << EOF
                FROM openjdk:11-jre-slim
                ADD ./target/${env.JOB_NAME}.war /home/${env.JOB_NAME}.war
                CMD ["nohup", "java", "-jar, "/home/${env.JOB_NAME}.war"]
                EOF
                """
            }
        }
    }
}
