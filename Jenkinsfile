pipeline {
    agent any

  environment {
   
    CLOUDSDK_CORE_PROJECT='iserveustaging'
    GCLOUD_CREDS=credentials('gcloud-creds')   
}

stages {

   
    stage('test') {
      steps {
        sh '''
          gcloud version
          gcloud auth activate-service-account --key-file="$GCLOUD_CREDS"
        '''
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
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
}