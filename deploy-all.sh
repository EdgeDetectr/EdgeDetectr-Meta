#!/bin/bash
set -e

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f ".env.deploy" ]; then
  echo "Loading environment variables from .env.deploy..."
  export $(grep -v '^#' .env.deploy | xargs)
else
  echo -e "${RED}ERROR: .env.deploy file not found!${NC}"
  echo "Please create this file from the .env.example template."
  exit 1
fi

# Print banner
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}          EdgeDetectr Deployment             ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo -e "This script will deploy both the frontend and backend components."
echo ""

# Feature information
echo -e "${BLUE}Features in this deployment:${NC}"
echo -e "- Image processing with multiple edge detection operators"
echo -e "- Client-side rate limiting (1 upload per 30 seconds)"
echo -e "- Responsive UI with real-time status updates"
echo -e "- Dockerized backend for scalable deployment"
echo ""

# Check if the ssl folder exists and warn about security
if [ -d "./ssl" ]; then
  echo -e "${YELLOW}Warning: SSL folder detected.${NC}"
  echo -e "This folder contains sensitive security materials and is excluded from git."
  echo -e "Remember to securely back up your SSL certificates separately from your repository."
  echo ""
fi

# Function to print section headers
print_section() {
  echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Function to print success messages
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error messages and exit
print_error() {
  echo -e "${RED}ERROR: $1${NC}"
  exit 1
}

# Function to print warning messages
print_warning() {
  echo -e "${YELLOW}! $1${NC}"
}

# Function to check if a file exists
check_file_exists() {
  if [ ! -f "$1" ]; then
    print_error "Required file '$1' does not exist!"
  fi
}

# Check for required deployment scripts
print_section "Checking prerequisites"
check_file_exists "./rebuild-backend.sh"
check_file_exists "./rebuild-frontend.sh"
print_success "All required scripts found"

# Make sure scripts are executable
chmod +x ./rebuild-backend.sh
chmod +x ./rebuild-frontend.sh

# 1. Deploy the backend first
print_section "Deploying Backend to AWS ECS"
echo "This may take several minutes..."

if ./rebuild-backend.sh; then
  print_success "Backend deployment initiated successfully"
else
  print_error "Backend deployment failed!"
fi

# 2. Check the backend health before proceeding
print_section "Checking Backend Health"
echo "Waiting 30 seconds for backend deployment to stabilize..."
sleep 30  # Give ECS some time to start deploying

# Check if NEXT_PUBLIC_API_URL is set in the environment
if [ -z "$NEXT_PUBLIC_API_URL" ]; then
  print_error "NEXT_PUBLIC_API_URL is not set in .env.deploy file"
fi

# Use the environment variable for API URL
API_URL=$NEXT_PUBLIC_API_URL

# Check if backend is responding
echo "Checking backend health at $API_URL/health..."
if curl -s "$API_URL/health" | grep -q "healthy"; then
  print_success "Backend is healthy and responding"
else
  print_warning "Backend health check failed. Deployment may still be in progress."
  read -p "Continue with frontend deployment anyway? (y/n): " continue_deploy
  if [[ $continue_deploy != "y" && $continue_deploy != "Y" ]]; then
    print_error "Deployment canceled by user"
  fi
fi

# 3. Deploy the frontend
print_section "Deploying Frontend to GitHub/AWS Amplify"

# Commit Message
read -p "Enter commit message for frontend changes: " COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
  COMMIT_MESSAGE="Update application"
  print_warning "Using default commit message: '$COMMIT_MESSAGE'"
fi

# Deploy frontend
if ./rebuild-frontend.sh "$COMMIT_MESSAGE"; then
  print_success "Frontend deployment initiated successfully"
else
  print_error "Frontend deployment failed!"
fi

# 4. Summarize deployment status
print_section "Deployment Summary"
echo "Backend: Deployed to AWS ECS"
echo "Frontend: Changes pushed to GitHub, AWS Amplify deployment triggered"
echo ""
echo "You can check the status of your deployments at:"
echo "- Backend: AWS ECS Console"

# Display custom domain information if set, using environment variables
if [ ! -z "$CUSTOM_DOMAIN" ]; then
  echo "- Frontend: AWS Amplify Console + Custom Domain (configured)"
  print_success "Custom domain is configured in environment variables"
else
  echo "- Frontend: AWS Amplify Console (using default Amplify domain)"
  print_warning "No custom domain detected. To set up a custom domain:"
  echo "1. Set CUSTOM_DOMAIN environment variable in .env.deploy"
  echo "2. Add the domain in AWS Amplify Console (Domain management)"
  echo "3. Follow the DNS configuration steps provided by Amplify"
  echo "4. Update ALLOWED_ORIGINS to include your custom domain"
fi

print_section "Next Steps"
echo "1. Wait for the Amplify deployment to complete (typically 2-5 minutes)"
echo "2. Verify your application is working correctly"
echo "3. Check for any Mixed Content errors in the browser console"

print_success "Deployment process completed successfully!" 