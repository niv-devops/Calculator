pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://18.193.75.162:9000'
        SONAR_TOKEN = credentials('sonarqube')
        ARTIFACTORY_URL = 'http://52.57.51.202:8082/artifactory/calc-local-repo/calculator'
        ARTIFACTORY_TOKEN = credentials('artifactory')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(
                        "calculator_app:latest",
                        "--build-arg SONAR_URL=${SONAR_URL} \
                         --build-arg SONAR_TOKEN=${SONAR_TOKEN} \
                         --build-arg ARTIFACTORY_URL=${ARTIFACTORY_URL} \
                         --build-arg ARTIFACTORY_TOKEN=${ARTIFACTORY_TOKEN} \
                         -t maven-build-test ."
                    )
                }
            }
        }
    }
    
    post {
        success {
            emailext (
                subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) succeeded",
                body: "Yay! The job '${JOB_NAME}' (${BUILD_NUMBER}) succeeded.\n\nBuild URL: ${BUILD_URL}",
                to: 'goofygitlab@gmail.com'
            )
        }
        failure {
            emailext (
                subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) failed",
                body: "Oh no, the job '${JOB_NAME}' (${BUILD_NUMBER}) failed.\n\nBuild URL: ${BUILD_URL}",
                to: 'goofygitlab@gmail.com'
            )
        }
    }
}
