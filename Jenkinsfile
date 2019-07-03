#!/usr/bin/env groovy

library 'BBCNews'

String cosmosService = 'belfrage'

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
    disableConcurrentBuilds(),
    parameters([
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

  stage('Set Cosmos config') {
    BBCNews.uploadCosmosConfig(cosmosService, params.ENVIRONMENT, "belfrage-build/cosmos_config/${params.ENVIRONMENT}-belfrage.json", params.FORCE_RELEASE)
  }

  if (params.ENVIRONMENT == 'test') {
    stage('Run tests') {
      docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=test") {
        sh 'mix deps.get'
        sh 'mix test'
        sh 'mix format --check-formatted'
      }
    }

    stage('Build RPM') {
      sh 'mkdir -p SOURCES'
      String vars = buildVariables()
      docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=prod ${vars}") {
        sh 'mix release'
      }
      sh 'cp _build/prod/rel/belfrage/releases/*/belfrage.tar.gz SOURCES/'
    }
    BBCNews.archiveDirectoryAsPackageSource('bake-scripts', 'bake-scripts.tar.gz')
    BBCNews.buildRPMWithMock(cosmosService, 'belfrage.spec', params.FORCE_RELEASE)
    BBCNews.setRepositories(cosmosService, 'belfrage-build/repositories.json')
    BBCNews.cosmosRelease(cosmosService, 'RPMS/*.x86_64.rpm', params.FORCE_RELEASE)
  }
}
