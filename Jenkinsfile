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

node {
  cleanWs()
  checkout scm

  properties([
    buildDiscarder(logRotator(daysToKeepStr: '7', artifactDaysToKeepStr: '7')),
    disableConcurrentBuilds(),
    parameters([
        choice(choices: ['belfrage', 'bruce-belfrage', 'cedric-belfrage', 'belfrage-preview'], description: 'The Cosmos Service to deploy to', name: 'SERVICE'),
        choice(choices: ['test', 'live'], description: 'The Cosmos environment to deploy to', name: 'ENVIRONMENT'),
        booleanParam(defaultValue: false, description: 'Force release from non-master branch', name: 'FORCE_RELEASE')
    ])
  ])

  stage('Checkout build variables from belfrage-build') {
    sh 'rm -rf belfrage-build'
    sh 'mkdir -p belfrage-build'
    dir('belfrage-build') {
      git url: 'https://github.com/bbc/belfrage-build', credentialsId: 'github', branch: 'master'
    }
  }

  if (params.ENVIRONMENT == 'test') {
    stage('Get Cosmos config from build repo') {
      sh "cp belfrage-build/cosmos_config/${params.SERVICE}.json cosmos/release-configuration.json"
    }

    stage('Run tests') {
      docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=test") {
        sh 'mix deps.get'
        sh 'mix test'
        sh 'mix test_e2e'
        sh 'mix routes_test'
        sh 'mix format --check-formatted'
      }
    }

    stage('Build RPM') {
      sh 'mkdir -p SOURCES'
      String vars = buildVariables()
      docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=prod ${vars}") {
        sh 'mix distillery.release'
      }
      sh 'cp _build/prod/rel/belfrage/releases/*/belfrage.tar.gz SOURCES/'
    }
    BBCNews.archiveDirectoryAsPackageSource('bake-scripts', 'bake-scripts.tar.gz')
    BBCNews.buildRPMWithMock(params.SERVICE, 'belfrage.spec', params.FORCE_RELEASE)
    BBCNews.setRepositories(params.SERVICE, 'belfrage-build/repositories.json')
    BBCNews.cosmosRelease(params.SERVICE, 'RPMS/*.x86_64.rpm', params.FORCE_RELEASE)
  }
  stage("clean up after ourselves") {
    cleanWs()
    dir("${env.WORKSPACE}@libs") {
      deleteDir()
    }
  }
}
