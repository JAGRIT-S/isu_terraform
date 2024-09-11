pipeline {
    agent any

    environment {
        // Use Jenkins credentials for GCP service account key
        //GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account-key') // Jenkins credential ID for the service account key
        //GCP_BUCKET = 'isu_public_bucket' // Replace with your bucket name
        GCP_PROJECT = 'iserveustaging' // Replace with your GCP project ID
        BASH = 'C:\\Program Files\\Git\\bin\\bash.exe'
    }

 stages {

        stage('Setup gcloud-Part1') {
            steps {
                script {
                    // Use Git Bash explicitly by invoking it via the BASH environment variable
                    sh """
                    "$BASH" -c '
                    # Run your commands inside Git Bash
                    echo "Setting up gcloud"
                    nohup your_command_here &
                    '
                    """
                }
            }
        }

    
        stage('Run Command') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'nohup your_command &'
                    } else {
                        bat 'start /B your_command'
                    }
                }
            }
        }
    

        stage('Setup gcloud') {
            steps {
                // Set up gcloud with the service account credentials and project
                script {
                    sh """
                    echo 'Setting up gcloud...'
                    gcloud config set project $GCP_PROJECT
                    """
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout the code from SCM (e.g., GitHub)
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                // Generate and show an execution plan
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the changes required to reach the desired state
                script {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
}