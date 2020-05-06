pipeline{

  agent any

  stages{
    stage("Download Tools"){
      steps{
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
          sh """
          mkdir /tmp/aws/
          cd /tmp/aws/
          curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -so "awscliv2.zip" 
          unzip -qo awscliv2.zip
          cd awscli
          sudo ./aws/install
          """
        }
      }
    }
  }
}