#!/usr/bin/env groovy

library 'BBCNews'

String cosmosService = 'ingress'

String buildVariables() {
  def envFile = readFile 'ingress-build/build.env'
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
        booleanParam(defaultValue: false, description: 'Force release from non-master branch', name: 'FORCE_RELEASE')
    ])
  ])

  stage('Run tests') {
    docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=test") {
      sh 'mix deps.get'
      sh 'mix test'
      sh 'mix format --check-formatted'
    }
  }

  stage('Checkout build variables from ingress-build') {
    sh 'rm -rf ingress-build'
    sh 'mkdir -p ingress-build'
    dir('ingress-build') {
      git url: 'https://github.com/bbc/ingress-build', credentialsId: 'github', branch: 'master'
    }
  }

  stage('Build RPM') {
    sh 'mkdir -p SOURCES'
    String vars = buildVariables()
    docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=prod ${vars}") {
      sh 'mix release'
    }
    sh 'cp _build/prod/rel/ingress/releases/*/ingress.tar.gz SOURCES/'
  }
  BBCNews.archiveDirectoryAsPackageSource('bake-scripts', 'bake-scripts.tar.gz')
  BBCNews.buildRPMWithMock(cosmosService, 'ingress.spec', params.FORCE_RELEASE)
  BBCNews.setRepositories(cosmosService, 'ingress-build/repositories.json')
  BBCNews.cosmosRelease(cosmosService, 'RPMS/*.x86_64.rpm', params.FORCE_RELEASE)
}
