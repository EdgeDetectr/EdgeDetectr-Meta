#!/bin/bash

# Load environment variables
if [ -f ".env.deploy" ]; then
  echo "Loading environment variables from .env.deploy..."
  export $(grep -v '^#' .env.deploy | xargs)
else
  echo "ERROR: .env.deploy file not found!"
  echo "Please create this file from the .env.example template."
  exit 1
fi

# Ensure the environment variables are loaded
if [ -z "$AWS_ACCOUNT_ID" ] || [ -z "$AWS_REGION" ]; then
  echo "Environment variables not set. Try running 'source load-env.sh' first."
  echo "You can also set them manually with:"
  echo "export AWS_ACCOUNT_ID=your_account_id"
  echo "export AWS_REGION=your_region"
  echo "... (and other required variables)"
  exit 1
fi

# Check if ALLOWED_ORIGINS is set
if [ -z "$ALLOWED_ORIGINS" ]; then
  echo "ERROR: ALLOWED_ORIGINS is not set in .env.deploy file"
  echo "This is required for CORS configuration."
  exit 1
fi

echo "Generating task-definition.json from template..."

# Create a copy of the template
cp task-definition-template.json task-definition.json

# Replace placeholders with actual values
sed -i '' "s/TASK_FAMILY_NAME/edgedetectr-backend/g" task-definition.json
sed -i '' "s/AWS_ACCOUNT_ID/$AWS_ACCOUNT_ID/g" task-definition.json
sed -i '' "s/AWS_REGION/$AWS_REGION/g" task-definition.json
sed -i '' "s/EXECUTION_ROLE_NAME/$EXECUTION_ROLE_NAME/g" task-definition.json
sed -i '' "s/CONTAINER_NAME/edgedetectr-backend-container/g" task-definition.json
sed -i '' "s/REPOSITORY_NAME/$REPOSITORY_NAME/g" task-definition.json
sed -i '' "s/LOG_GROUP_NAME/$LOG_GROUP_NAME/g" task-definition.json
sed -i '' "s#ALLOWED_ORIGINS#$ALLOWED_ORIGINS#g" task-definition.json

echo "Task definition generated successfully!"
echo "You can now register it with AWS ECS using:"
echo "aws ecs register-task-definition --cli-input-json file://task-definition.json" 