pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 3, unit: 'HOURS')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '15', artifactNumToKeepStr: '3'))
    }

    triggers {
        pollSCM('H/15 * * * *')
    }

    environment {
        DL_DIR     = '/var/lib/isar-cache/downloads'
        SSTATE_DIR = '/var/lib/isar-cache/sstate'
        DEPLOY     = 'build/tmp/deploy/images/qemuamd64'
        IMAGE      = 'lab-image-debian-bookworm-qemuamd64'
    }

    stages {
        stage('Build image') {
            steps {
                sh './kas-container build lab.yml'
            }
        }

        stage('Boot smoke test') {
            steps {
                sh './ci/smoke-test.sh "${DEPLOY}/${IMAGE}.wic" boot.log'
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: "${env.DEPLOY}/${env.IMAGE}.wic, ${env.DEPLOY}/${env.IMAGE}.manifest",
                                 fingerprint: true
                archiveArtifacts artifacts: "${env.DEPLOY}/*.json",
                                 allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'boot.log', allowEmptyArchive: true
        }
    }
}