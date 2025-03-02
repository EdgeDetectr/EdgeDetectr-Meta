#!/bin/bash

# Script to load environment variables from .env.deploy file
echo "Loading deployment environment variables..."

if [ -f .env.deploy ]; then
  # Export all variables from the .env.deploy file
  export $(grep -v '^#' .env.deploy | xargs)
  echo "Environment variables loaded successfully!"
  
  # List loaded variables without showing their values
  echo "The following variables are now available:"
  echo "- AWS_ACCOUNT_ID: [HIDDEN]"
  echo "- AWS_REGION: $AWS_REGION"
  echo "- CLUSTER_NAME: $CLUSTER_NAME"
  echo "- SERVICE_NAME: $SERVICE_NAME"
  echo "- REPOSITORY_NAME: $REPOSITORY_NAME"
  
  # Include Amplify variables in the list
  echo "- AMPLIFY_APP_ID: [HIDDEN]"
  echo "- AMPLIFY_BRANCH: $AMPLIFY_BRANCH"
  echo "- NEXT_PUBLIC_API_URL: [HIDDEN]"
  echo "- ALLOWED_ORIGINS: [HIDDEN]"
  
  echo ""
  echo "You can now run your deployment scripts that use these variables."
else
  echo "Error: .env.deploy file not found!"
  echo "Please create this file with your AWS credentials and settings."
  echo "You can use .env.deploy.example as a template."
  exit 1
fi 