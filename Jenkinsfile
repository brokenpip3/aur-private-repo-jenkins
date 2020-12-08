pipeline {                                                                                               
  agent {
    kubernetes {
      yaml """
kind: Pod
metadata:
  name: aurbuild
spec:
  containers:
  - name: jnlp
    workingDir: /tmp/jenkins
  - name: aurbuild
    workingDir: /tmp/jenkins
    image: brokenpip3/dockerbaseciarch:1.7
    imagePullPolicy: Always
    command:
    - /usr/bin/cat
    tty: true
    resources:
      limits:
        memory: 2Gi
        cpu: 2
        ephemeral-storage: 5Gi
      requests:
        memory: 1Gi
        cpu: 1
        ephemeral-storage: 3Gi
    volumeMounts:
      - name: repo-pvc
        mountPath: /srv/repo
  imagePullSecrets:
  - name: registry-brokenpip3
  volumes:
  - name: repo-pvc
    persistentVolumeClaim: 
      claimName: repo-pvc
"""
    }}
        options { disableConcurrentBuilds() }

  parameters {
        string(name: 'PACKAGENAME', defaultValue: 'trizen', description: 'Aur package to build')}

  stages {
    stage("Setname") {
            steps {
                // use name of the patchset as the build name
                buildName "${params.PACKAGENAME} #${BUILD_NUMBER}"
                buildDescription "${BUILD_NUMBER}"
            }
        }
    stage('pacman update') {
      steps {
		    container('aurbuild') {
            sh 'sudo pacman -Sy'
        }
       }
      }
    stage('gpg keys') {
      steps {
		    container('aurbuild') {
            sh './gpgkeys.sh'
        }
       }
      }
    stage("download") {
      steps {
		    container('aurbuild') {
            sh "curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/${params.PACKAGENAME}.tar.gz"
            sh "tar -xvf ${params.PACKAGENAME}.tar.gz"
        }
      }
    }
    stage('install dep') {
      steps {
		container('aurbuild')
    {
      sh "cd ${params.PACKAGENAME} && makepkg -s -o --noconfirm"
    }
    }
    }
    stage('build') {
      steps {
		container('aurbuild')
    {
      sh "cd ${params.PACKAGENAME} && makepkg -scf --noconfirm"
    }
    }
    }
    stage('update repo') {
      steps {
	    container('aurbuild')
          {
          sh "pacman -Sl |grep -q ${params.PACKAGENAME} && rm /srv/repo/${params.PACKAGENAME}-*"
          sh "repoctl add -m /tmp/${params.PACKAGENAME}-*"
          }
    }
    }
}
}
