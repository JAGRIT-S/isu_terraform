pipeline {
    agent any

    environment {
        // Define your GCP credentials and bucket name
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account-key') // Jenkins credential ID for GCP service account key
        GCP_BUCKET = 'your-gcp-bucket-name' // Replace with your bucket name
    }

    stages {
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

        stage('Upload State File to GCS') {
            steps {
                // Upload the Terraform state file to GCS bucket
                script {
                    // Set GCP project (optional, if needed)
                    sh 'gcloud config set project your-gcp-project-id' // Replace with your GCP project ID

                    // Copy the state file to the GCS bucket
                    sh """
                    if [ -f terraform.tfstate ]; then
                        gsutil cp terraform.tfstate gs://${GCP_BUCKET}/terraform-states/terraform.tfstate-\$(date +%Y-%m-%d_%H-%M-%S)
                    fi
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up Terraform plan file after the pipeline run
            script {
                sh 'rm -f tfplan'
            }
        }
        failure {
            // Notify on failure (can be email, Slack, etc.)
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
