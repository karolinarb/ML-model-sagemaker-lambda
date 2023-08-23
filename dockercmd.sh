#!/bin/bash

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 863534173996.dkr.ecr.eu-west-2.amazonaws.com
docker build -t ml-pipeline-sagemaker-repo .
docker tag ml-pipeline-sagemaker-repo:latest 863534173996.dkr.ecr.eu-west-2.amazonaws.com/ml-pipeline-sagemaker-repo:latest
docker push 863534173996.dkr.ecr.eu-west-2.amazonaws.com/ml-pipeline-sagemaker-repo:latest