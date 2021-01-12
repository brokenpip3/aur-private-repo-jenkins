pipeline {
  agent {
    kubernetes {
      yaml """
kind: Pod
metadata:
  name: aurbuild
spec:
  containers:
  - name: aurbuild
    workingDir: /tmp/jenkins
    image: brokenpip3/dockerbaseciarch:1.9
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
      claimName: new-repo-pvc
"""
    }}
        options { disableConcurrentBuilds()
                    timeout(time: 10, unit: 'MINUTES')
                }

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
      sh "cd ${params.PACKAGENAME} && makepkg -scf --noconfirm | tee /tmp/${params.PACKAGENAME}.log"
    }
    }
    }
    stage('update repo') {
      steps {
	    container('aurbuild')
          {
          sh "repo-add -R -p /srv/repo/needrelax.db.tar.zst /srv/repo/${params.PACKAGENAME}-*"
          }
    }
    } 
}
 post {
        failure {
            sh """

            /usr/bin/curl --silent --output /dev/null \
              --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
              --data-urlencode "text=*CI-CD* package ${params.PACKAGENAME} failed ${BUILD_URL}/console " \
              --data-urlencode "parse_mode=Markdown" \
              --data-urlencode "disable_web_page_preview=true" \
              "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
            """
            }
    }
}
