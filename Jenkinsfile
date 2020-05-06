pipeline{

  agent any

  stages{
    stage("Download Terraform"){
      steps{
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
          sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip -q awscliv2.zip && sudo ./aws/install'
        }
      }
    }
  }
}