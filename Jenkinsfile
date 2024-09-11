pipeline {
    agent any
    stages {
        stage('Setup gcloud') {
            steps {
                // Use `bat` for batch commands on Windows
                bat 'gcloud init'
            }
        }
        stage('Terraform Init') {
            steps {
                // Use `bat` for Windows shell execution
                bat 'terraform init'
            }
        }
        stage('Run Background Command') {
            steps {
                // Replace `nohup` with `start /b` for running commands in the background on Windows
                bat 'start /b gcloud auth login'
            }
        }
    }
    post {
        always {
            // Clean up resources or perform any required actions after pipeline execution
            bat 'gcloud auth revoke'
        }
    }
}
