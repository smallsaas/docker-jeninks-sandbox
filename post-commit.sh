#!/bin/sh

### guide ##
## https://stackoverflow.com/questions/5784329/how-can-i-make-jenkins-ci-with-git-trigger-on-pushes-to-master
#####

jenkins_host='http://192.168.3.237:8000'
api_token='f1c55b3a07bb2b69b9dd549e96898384'
jos_name='gmic-cad-web-pages'


#curl -u userName:apiToken -X POST http://localhost:8080/jenkins/job/jobName/build?token=apiToken
echo curl -u jenkins:$api_token -X POST $jenkins_host/jenkins/job/$jos_name/build?token=$api_token

