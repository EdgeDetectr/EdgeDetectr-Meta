#!/bin/bash
set -e

# Environment variables that should be set locally:
# AWS_ACCOUNT_ID - Your AWS account ID
# AWS_REGION - Your AWS region (e.g., us-east-1)
# CLUSTER_NAME - Your ECS cluster name
# SERVICE_NAME - Your ECS service name
# REPOSITORY_NAME - Your ECR repository name

echo "Building updated backend container..."
cd backend
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Building for linux/amd64 platform..."
docker buildx build --platform=linux/amd64 -t $REPOSITORY_NAME:latest .
docker tag $REPOSITORY_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:latest

echo "Updating ECS service to use the new image..."
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --force-new-deployment
aws ecs wait services-stable --cluster $CLUSTER_NAME --services $SERVICE_NAME

echo "Deployment completed successfully!" 