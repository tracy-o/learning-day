#!/usr/bin/env groovy

library 'devops-tools-jenkins'

def dockerRegistry = libraryResource('dockerregistry').trim()
def dockerImage = "${dockerRegistry}/bbc-news/elixir-centos7:1.14.3-erlang-24.3.4.8"

library 'BBCNews'

String buildVariables() {
  def envFile = readFile 'belfrage-build/build.env'
  def envVars = ''
  envFile.split('\n').each { env ->
    envVars = "$envVars -e $env"
  }
  envVars
}

def buildStack(branch, stack_name, environment="test") {
  build(
    job: "belfrage-multi-stack/$branch",
    parameters: [
      [$class: 'StringParameterValue', name: 'SERVICE', value: stack_name],
      [$class: 'BooleanParameterValue', name: 'FORCE_RELEASE', value: false],
      [$class: 'StringParameterValue', name: 'DEPLOYMENT_ENVIRONMENT', value: environment]
    ],
    propagate: false,
    wait: false
  )
}

node {
  cleanWs()
  checkout scm

  properties([
    buildDiscarder(logRotator(daysToKeepStr: '7', artifactDaysToKeepStr: '7')),
    disableConcurrentBuilds()
  ])

  stage('Run tests') {
    docker.image(dockerImage).inside("-u root -e MIX_ENV=test") {
      sh 'mix deps.get'
      sh 'mix test'
    }
  }

  stage('Code Analysis Checks') {
    docker.image(dockerImage).inside("-u root -e MIX_ENV=test") {
      sh 'mix format --check-formatted'
      sh 'mix credo'
    }
  }

  stage ('Deploy Multi Stacks') {
    def jobNameList = env.JOB_NAME.tokenize('/') as String[];
    def branchName = jobNameList[2];

    node {
      buildStack(branchName, "belfrage", "live")
      buildStack(branchName, "belfrage-preview")
      buildStack(branchName, "bruce-belfrage")
      buildStack(branchName, "cedric-belfrage")
      buildStack(branchName, "joan-belfrage")
      buildStack(branchName, "sally-belfrage")
      buildStack(branchName, "sydney-belfrage")
    }
  }

  stage("clean up after ourselves") {
    docker.image(dockerImage).inside("-u root") {
        sh "rm -rf ${env.WORKSPACE}/{deps,_build,local.log}"
    }
    cleanWs()
    dir("${env.WORKSPACE}@libs") {
      deleteDir()
    }
  }
}
