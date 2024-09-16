pipeline {
    agent any

    environment {
        CLOUDSDK_CORE_PROJECT = 'iserveustaging'
        GCLOUD_CREDS = credentials('gcloud-creds')   
        Email = 'jagrit.s@iserveu.co.in'
    }

    stages {

        stage('Test') {
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
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    try {
                        // Send an email for approval
                        emailext (
                            to: "${env.Email}",
                            replyTo: 'devops-git@iserveu.in',
                            subject: "Waiting for Jagrit Approval! Job: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                            body: """
                            Waiting for Jagrit Approval! Job: \n\nConsole: ${env.BUILD_URL}.
                            \n\nSTARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':
                            Check console output at "${env.JOB_NAME} [${env.BUILD_NUMBER}]"
                            """,
                            recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                        )

                        // Timeout for 30 minutes while waiting for approval
                        timeout(time: 30, unit: 'MINUTES') {
                            input message: 'Waiting for Jagrit Approval!', submitter: 'jagrit.s@iserveu.co.in'
                        }

                        // If approved, run terraform apply
                        sh 'terraform apply -auto-approve tfplan'
                    } catch (Exception e1) {
                        // Handle exception and send failure email
                        if (currentBuild.result == 'ABORTED') {
                            emailext (
                                to: "${env.Email}",
                                replyTo: 'devops-git@iserveu.in',
                                subject: "Jenkins Build Aborted: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                                body: "Jenkins Build aborted, please check details.\n\nConsole: ${env.BUILD_URL}.\n\n",
                                mimeType: 'text/html',
                                attachLog: true
                            )
                            currentBuild.result = 'ABORTED'
                        } else {
                            // Send email if terraform apply fails
                            emailext (
                                to: "${env.Email}",
                                replyTo: 'devops-git@iserveu.in',
                                subject: "Jenkins Terraform Apply Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                                body: "Jenkins Terraform apply failed. Please check the logs.\n\nConsole: ${env.BUILD_URL}.\n\n",
                                mimeType: 'text/html',
                                attachLog: true
                            )
                            error("Terraform apply failed")
                        }
                    }
                }
            }
        }
    }
}
