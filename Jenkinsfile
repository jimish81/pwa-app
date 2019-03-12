pipeline {
  environment{
    registry = "mazuma5/pipeline-project"
    registryCredential = 'Dockerhub'
    dockerImage = ''
    containerId = sh(script: 'docker ps -aqf "name=pwa-node-app"', returnStdout:true)
  }
  agent any
  tools {
    nodejs "node"
    maven 'Maven'
    jdk 'JDK'
  }
    
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/mazuma5/pwa-app'
      }
    }
        
    stage('Build') {
      steps {
        sh 'npm install --save-dev @angular-devkit/build-angular'
        sh 'ng build --prod'
      }
    }
     
   /* stage('Test') {
      steps {
         sh 'npm test'
      }
    }*/
    stage('Building Image'){
      steps{
        script{
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    
    stage('Push Image'){
      steps{
        script{
          docker.withRegistry('',registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
    
    stage('Cleanup'){
      when{
        not {environment ignoreCase:true, name:'containerId', value:''}
      }
      steps {
        sh 'docker stop ${containerId}'
        sh 'docker rm ${containerId}'
      }
    }
    stage('Run Container'){
      steps{
        sh 'docker run --name=pwa-node-app -d -p 3000:8080 $registry:$BUILD_NUMBER &'
      }
    }
    
    stage('Clone Selenium Git'){
      steps{
        git 'https://github.com/mazuma5/JavaSeleniumBDD/tree/linux'
      }
    }
    
    stage('Build') {
      steps {
        sh "chmod +x src/main/resources/drivers/chromedriverlinux"
        sh "mvn test"
      }
    }  
    
  }
}
