#!/usr/bin/env groovy

library 'BBCNews'

String buildVariables() {
  def envFile = readFile 'belfrage-build/build.env'
  def envVars = ''
  envFile.split('\n').each { env ->
    envVars = "$envVars -e $env"
  }
  envVars
}

def buildStack(branch, stack_name) {
  build(
    job: "belfrage-multi-stack/$branch",
    parameters: [
      [$class: 'StringParameterValue', name: 'SERVICE', value: stack_name],
      [$class: 'BooleanParameterValue', name: 'FORCE_RELEASE', value: false]
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
    docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=test") {
      sh 'mix deps.get'
      sh 'mix test'
      sh 'mix test_e2e'
      sh 'mix routes_test'
      sh 'mix format --check-formatted'
      sh 'mix credo'
    }
  }

  stage ('Deploy Multi Stacks') {
    def jobNameList = env.JOB_NAME.tokenize('/') as String[];
    def branchName = jobNameList[2];

    node {
      buildStack(branchName, "belfrage")
      buildStack(branchName, "belfrage-preview")
      buildStack(branchName, "bruce-belfrage")
      buildStack(branchName, "cedric-belfrage")
    }
  }

  stage("clean up after ourselves") {
    docker.image('qixxit/elixir-centos').inside("-u root") {
        sh "rm -rf ${env.WORKSPACE}/{deps,_build,local.log}"
    }
    cleanWs()
    dir("${env.WORKSPACE}@libs") {
      deleteDir()
    }
  }
}
