#!/bin/bash
set -e

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== EdgeDetectr Frontend Deployment ===${NC}"
echo "This script will commit and push your frontend changes to GitHub."
echo "Amplify will automatically deploy from the GitHub repository."

# Navigate to the frontend directory
cd EdgeDetectr-Frontend

# Show current status
echo -e "\n${YELLOW}Current git status:${NC}"
git status

# Prompt for commit message
echo -e "\n${YELLOW}Enter your commit message:${NC}"
read -p "> " COMMIT_MESSAGE

if [ -z "$COMMIT_MESSAGE" ]; then
  COMMIT_MESSAGE="Update frontend application"
  echo "Using default commit message: $COMMIT_MESSAGE"
fi

# Add all changes
echo -e "\n${YELLOW}Adding all changes...${NC}"
git add .

# Commit with the provided message
echo -e "\n${YELLOW}Committing changes...${NC}"
git commit -m "$COMMIT_MESSAGE"

# Push to the remote repository
echo -e "\n${YELLOW}Pushing to GitHub...${NC}"
git push origin main

echo -e "\n${GREEN}Frontend changes pushed successfully!${NC}"
echo "Amplify will automatically detect the changes and deploy the new version."
echo "You can check the build status in the AWS Amplify Console."

# Return to the original directory
cd ..

# Optionally display the Amplify app URL
if [ ! -z "$AMPLIFY_APP_ID" ]; then
  echo -e "\n${YELLOW}Amplify app URL:${NC} https://main.${AMPLIFY_APP_ID}.amplifyapp.com"
fi 