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
                        echo pwd
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
                    sh """
                    cat > Dockerfile << EOF
FROM tomcat:9-jre8-alpine
WORKDIR /usr/local/tomcat
COPY server.xml ./conf
COPY pom.xml ./conf
RUN rm -rf ./webapps/*
ARG JAR_FILE=*.war
COPY ./target/${env.JOB_NAME}.war ./webapps/${env.JOB_NAME}.war
CMD ["nohup", "java", "-jar", "./webapps/${env.JOB_NAME}.war", "&"]
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
