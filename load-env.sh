#!/bin/bash

# Script to load environment variables from .env.deploy file
echo "Loading deployment environment variables..."

if [ -f .env.deploy ]; then
  # Export all variables from the .env.deploy file
  export $(grep -v '^#' .env.deploy | xargs)
  echo "Environment variables loaded successfully!"
  echo "The following variables are now available:"
  echo "- AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"
  echo "- AWS_REGION: $AWS_REGION"
  echo "- CLUSTER_NAME: $CLUSTER_NAME"
  echo "- SERVICE_NAME: $SERVICE_NAME"
  echo "- REPOSITORY_NAME: $REPOSITORY_NAME"
  echo ""
  echo "You can now run your deployment scripts that use these variables."
else
  echo "Error: .env.deploy file not found!"
  echo "Please create this file with your AWS credentials and settings."
  exit 1
fi 