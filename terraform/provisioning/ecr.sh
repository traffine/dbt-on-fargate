#!/bin/bash

# Read variables
read -p "Enter environment name for ECR: " ENV
read -p "Enter app name: " APP_NAME
read -p "Enter image name: " IMAGE_NAME

# Create ECR repo
aws ecr create-repository \
  --repository-name ${ENV}-${APP_NAME}-${IMAGE_NAME} \
  --image-tag-mutability MUTABLE \
  --encryption-configuration encryptionType=AES256

# Change scanning policy
aws ecr put-image-scanning-configuration \
  --repository-name ${ENV}-${APP_NAME} \
  --image-scanning-configuration scanOnPush=false

# Apply lifecycle policy
aws ecr put-lifecycle-policy \
  --repository-name ${ENV}-${APP_NAME} \
  --lifecycle-policy-text '{
    "rules": [
      {
        "rulePriority": 1,
        "description": "Leave the latest five images",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 5
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }'
