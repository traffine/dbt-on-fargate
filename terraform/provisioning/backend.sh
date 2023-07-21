#!/bin/bash
set -e

CFN_TEMPLATE=backend.yml

echo Let us create S3 and DynamoDB for Terrafrom backend.

# Read variables
read -p "Enter unique S3 bucket name for Terraform Backend: " TF_S3_BUCKET_NAME
read -p "Enter dynamodb name for Terraform Backend: " TF_DYNAMO_NAME
read -p "Enter Cloudformation stack name for Terraform Backend: " CFN_STACK_NAME

# Create S3 Bucket and DynamoDB
echo Create S3 Bucket and DynamoDB with Cloudformation ...

aws cloudformation deploy \
  --stack-name ${CFN_STACK_NAME} \
  --template-file ${CFN_TEMPLATE} \
  --parameter-overrides S3BucketName=${TF_S3_BUCKET_NAME} DynamoDBTableName=${TF_DYNAMO_NAME}

echo Done!!
