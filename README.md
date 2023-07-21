# dbt on ECS Fargate

## Architecture

The architecture is shown in the figure below.

![ELT pipeline](/img/dbt-fargate.png)

## Construction Procedure

Below are the steps to build an infrastructure for running dbt on ECS Fargate.

1. Provisioning ECR
2. Creating S3 and DynamoDB for Terraform Backend
3. Pushing dbt Docker image to ECR
4. Applying Terraform configuration

### 1. Provisioning ECR

Execute /provisioning/ecr.sh.

- You will be asked to enter the environment name (`prod`).
- Then, enter the app name (`my-elt`).
- Finally, enter the image name (`dbt`).

```bash
$ sh provisioning.ecr.sh

Enter environment name for ECR:
Enter app name:
Enter image name:
```

An ECR repository will be created with the name `<env>-<app name>-<image name>`.

### 2. Creating S3 and DynamoDB for Terraform Backend

Run `/provisioning/backend.sh`.

- When prompted, enter a unique S3 bucket name for Terraform Backend (e.g., `prod-my-elt`).
- Enter a name for the DynamoDB table for Terraform Backend (e.g., `prod-my-elt`).
- Provide a CloudFormation stack name for Terraform Backend (e.g., `prod-my-elt`).

```bash
$ sh provisioning.backend.sh

Enter unique S3 bucket name for Terraform Backend:
Enter dynamodb name for Terraform Backend:
Enter Cloudformation stack name for Terraform Backend:
```

A S3 bucket and a DynamoDB table named `prod-my-elt` will be created.

### 3. Pushing dbt Docker Image to ECR

Create and push the dbt Docker image using `/dbt/Dockerfile` (`<prod-my-elt-dbt>` should follow the name used during ECR creation).

```bash
$ cd dbt

$ aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com

$ docker build --platform amd64 -t <prod-my-elt-dbt> .

$ docker tag dev-elt-dbt:latest 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/<prod-my-elt-dbt>:latest

$ docker push 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/<prod-my-elt-dbt>:latest
```

### 4. Applying Terraform Configuration

Execute terraform apply to create the following resources:

- VPC
- Public Subnet
- Internet Gateway (IGW)
- Security Group
- CloudWatch
- ECS Cluster
- ECS Task Definition
- EventBridge: Cron trigger for Step Functions
- Step Functions: DAG for ELT (executing dbt)

```bash
$ cd terraform/aws/dev

$ terraform apply
```
