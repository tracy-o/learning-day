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

def buildStack(branch, stack_name, force_release) {
  build(
    job: "belfrage-multi-stack/$branch",
    parameters: [
      [$class: 'StringParameterValue', name: 'SERVICE', value: stack_name],
      [$class: 'BooleanParameterValue', name: 'FORCE_RELEASE', value: force_release]
    ],
    propagate: true
  )
}

node {
  cleanWs()
  checkout scm

  properties([
    buildDiscarder(logRotator(daysToKeepStr: '7', artifactDaysToKeepStr: '7')),
    disableConcurrentBuilds(),
    parameters([
        booleanParam(defaultValue: false, description: 'Force release from non-master branch', name: 'FORCE_RELEASE')
    ])
  ])

  stage('Run tests') {
    docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=test") {
      sh 'mix deps.get'
      sh 'mix test'
      sh 'mix test_e2e'
      sh 'mix routes_test'
      sh 'mix format --check-formatted'
    }
  }

  stage ('Deploy Multi Stacks') {
    def jobNameList = env.JOB_NAME.tokenize('/') as String[];
    def branchName = jobNameList[2];

    parallel {
        stage('Deploy Belfrage') {
            buildStack(branchName, "belfrage", params.FORCE_RELEASE)
        }
        stage('Deploy Belfrage Preview') {
            buildStack(branchName, "belfrage-preview", params.FORCE_RELEASE)
        }
        stage('Deploy Bruce Belfrage') {
            buildStack(branchName, "bruce-belfrage", params.FORCE_RELEASE)
        }
        stage('Deploy Cedric Belfrage') {
            buildStack(branchName, "cedric-belfrage", params.FORCE_RELEASE)
        }
    }
  }

  stage("clean up after ourselves") {
    cleanWs()
    dir("${env.WORKSPACE}@libs") {
      deleteDir()
    }
  }
}
