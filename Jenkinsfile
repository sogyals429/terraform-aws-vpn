pipeline{

  agent any

  stages{
    stage("Configure Environment"){
      steps{
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
          withCredentials([string(credentialsId: 'ACCESS_KEY', variable: 'ACCESS_KEY')]) { //set SECRET with the credential content
          sh """
          aws configure set aws_access_key_id ${ACCESS_KEY}
          """
          }
          withCredentials([string(credentialsId: 'AWS_SECRET', variable: 'AWS_SECRET_KEY')]) { //set SECRET with the credential content
          sh """
          aws configure set aws_secret_access_key ${AWS_SECRET_KEY}
          """
          }

          sh """
          aws configure set region 'ap-southeast-2'
          """
          
        }
      }
    }
    stage("Download Terraform"){
      steps{
         wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
           sh """
            wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
            unzip -o terraform_0.12.24_linux_amd64.zip
          """
         }
      }
    }
    stage("Deploy"){
      steps{
         wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
           sh """
          ls
           rm -rf .terraform/ && terraform init
            make vpn
          """
         }
      }
    }
  }
}