pipeline {
    agent any
    
    tools {
        maven 'mvn'
    }
    
    environment {
        repository = 'imyujinsim/edu-msa-ui'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        GIT_AUTH = credentials('github')
        imyujinsim = credentials('imyujinsim')
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
                        cd /var/lib/jenkins/workspace/${env.JOB_NAME}
                        mvn clean install
                        mv ./target/*.war ./target/ROOT.war
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
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY ./target/ROOT.war /usr/local/tomcat/webapps/ROOT.war
COPY ./server.xml /usr/local/tomcat/conf
ARG JAR_FILE=*.war
CMD ["nohup", "java", "-jar", "/usr/local/tomcat/webapps/ROOT.war", "&"]

EXPOSE 28080
                    """

                    app = docker.build("$repository:$BUILD_NUMBER")

                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Create YAML File and Push it to CD Repository') {
            environment {
                GIT_AUTH = credentials('github')
            }

            steps {
                script {
                    sh """
                        #!/bin/bash
                        cat>deploy.yaml<<-EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kpaas-ui
  namespace: kpaas
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kpaas-ui
  template:
    metadata:
      labels:
        app: kpaas-ui
    spec:
      containers:
      - image: $repository:$BUILD_NUMBER 
        name: kpaas-ui
EOF"""

                    sh """
                git config --global user.name 'user'
                git config --global user.email 'user@noreply.example.com'
                git clone https://github.com/imyujinsim/kpaas-argocd.git
                mv deploy.yaml ./kpaas-argocd/deploy.yaml
                cd kpaas-argocd
                git add .
                git commit -m 'deploy file ${env.BUILD_NUMBER}'
                git push https://$imyujinsim@github.com/imyujinsim/kpaas-argocd.git
                cd ..
                rm -rf kpaas-argocd
            """
    }
                }
            }
        }
    }
