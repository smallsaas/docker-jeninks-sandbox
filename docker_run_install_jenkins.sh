#!/bin/bash
docker run --name jenkins \
       -d \
       -p 8000:8000 \
       -v ./jenkins_home:/jenkins_home \
       --restart always \
       jenkins/jenkins:lts