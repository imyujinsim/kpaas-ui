pipeline {
    agent any
    
    tools {
        maven 'maven'
    }
    
    environment {
        repository = 'imyujinsim/edu-msa-ui'
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
                        sh """
                        mvn clean install
                        mv target/*.war target/${env.JOB_NAME}.war
                        """
                    } catch(error) {
                        print('error')
                        sh "rm -rf /var/lib/jenkins/workspace/*"
                    }
                }
            }
        }
        
        stage('Make Docker Image and Push') {
            steps {
                script {
                    sh "echo whoami"
                    sh """
                    cat > Dockerfile << EOF
                    FROM openjdk:8-jre-slim
                    ADD ./target/${env.JOB_NAME}.war /home/${env.JOB_NAME}.war
                    CMD ["nohup", "java", "-jar, "/home/${env.JOB_NAME}.war"]
                    """

                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    docker.build("$repository:$BUILD_NUMBER")
                    sh "docker push $repository:$BUILD_NUMBER"
                    sh "docker rmi $repository:$BUILD_NUMBER"
                }
            }
        }
    }
}
