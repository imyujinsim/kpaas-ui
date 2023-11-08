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
                    sh """
                    cat > Dockerfile << EOF
                    FROM openjdk:11-jre-slim
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

        stage('Make yaml file') {
            steps {
                script {
                    sh """
             cat <<EOF > monthly_deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kpaas-ui-deployment
  labels:
    app: kpaas-ui
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
      - name: kpaas-ui
        image: docker.io/imyujinsim/edu-msa-ui:${BUILD_NUMBER}
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metedata :
  name: kpaas-ui
  labels:
    app: kpaas-ui
spec:
  selector:
    app: kpaas-ui
  type: NodePort
  port: 9090
  targetPort: 5000 
"""
                }
            }
        }
    }
}
