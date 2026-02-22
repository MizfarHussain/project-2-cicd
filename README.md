# Project 2 CI/CD

CI/CD pipeline for a Node.js app deployed to AWS ECS (Fargate) using GitHub Actions
and Terraform.

## Contents

- `app.js` - sample Node.js app
- `Dockerfile` - container build
- `.github/workflows/deploy-aws.yml` - GitHub Actions pipeline
- `terraform/` - AWS infrastructure (ECR, ECS, IAM, networking)

## Prerequisites

- Node.js 18+
- Docker
- Terraform 1.x
- An AWS account with permissions to create ECS/ECR/IAM resources

## Terraform setup

1. Update `terraform/terraform.tfvars` with your values.
2. Initialize and apply:

   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

3. Copy the outputs for GitHub Secrets (see below).

## GitHub Secrets

Add the following repository secrets using the Terraform outputs:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `ECR_REPOSITORY`
- `ECS_CLUSTER`
- `ECS_SERVICE`
- `ECS_TASK_DEFINITION`

## Pipeline behavior

- Runs on pushes and PRs to `main` that change `project-2-cicd/**`
- Tests the app, builds the Docker image, pushes to ECR
- Updates the ECS task definition and deploys the service
- Prints the public URL once the service is stable

## Local run

```bash
npm ci
npm test
node app.js
```
new line added to test