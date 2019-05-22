#!/usr/bin/env groovy

library 'BBCNews'

node {
  cleanWs()
  checkout scm

  properties([
    disableConcurrentBuilds()
  ])

  stage('Run tests') {
    docker.image('qixxit/elixir-centos').inside("-u root -e MIX_ENV=test") {
      sh 'mix deps.get'
      sh 'mix test'
      sh 'mix format --check-formatted'
    }
  }

  stage('Build RPM') {
    if (env.BRANCH_NAME == 'master') {
      build '../ingress-build/master'
    }
  }
}
