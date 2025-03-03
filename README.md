# EdgeDetectr

EdgeDetectr is a full-stack web application for applying image processing operators (Sobel, Prewitt, Roberts, etc.) to uploaded images. The project consists of:

- **Frontend**: A Next.js application for user interaction.
- **Backend**: An Express.js server that handles image uploads and processing.
- **Operators**: A C++ module using OpenCV to apply edge detection operators.
- **Deployment**: 
  - Backend: Containerized using Docker and deployed to AWS ECS
  - Frontend: Deployed to AWS Amplify

## 🎥 Demo
https://github.com/user-attachments/assets/47b9ef04-d53f-4267-a9d8-3cf7a6b2d60c


## 🚀 Features
- Upload an image via the frontend.
- Choose an edge detection operator (Sobel, Prewitt, Roberts, etc.).
- Process the image on the backend using C++ and OpenCV.
- Retrieve and display the processed image.
- Rate limiting to prevent abuse (maximum 1 upload every 30 seconds).
- Fully containerized for easy deployment.

---

## 🛠️ Installation

### Prerequisites
- **Docker** (for containerization)
- **Docker Compose** (to manage multi-container applications)

### Clone the Repository
```sh
# Clone main repo and submodules
git clone --recurse-submodules https://github.com/your-org/EdgeDetectr-Meta.git
cd EdgeDetectr-Meta
```

### Build & Run Containers Locally
```sh
docker-compose up --build
```
This runs **frontend, backend, and operators** in separate containers.

---

## Deployment

### Environment Setup

To deploy the application, you'll need to set up environment variables with your AWS account information:

```bash
# For backend deployment
export AWS_ACCOUNT_ID=your_aws_account_id
export AWS_REGION=your_aws_region
export CLUSTER_NAME=edgedetectr-cluster
export SERVICE_NAME=edgedetectr-backend
export REPOSITORY_NAME=edgedetectr-backend
```

The frontend deployment now uses GitHub, so you only need the Amplify App ID for informational purposes:
```bash
# Optional: for displaying Amplify app URL
export AMPLIFY_APP_ID=your_amplify_app_id
```

> Note: Environment variables for the frontend application itself (like `NEXT_PUBLIC_API_URL`) should be configured directly in the AWS Amplify Console.

### Using the Deployment Templates

This repository includes template files for deploying to AWS:

1. `rebuild-backend-template.sh` - Template for building and deploying the backend to ECS
2. `rebuild-frontend-template.sh` - Template for deploying the frontend to AWS Amplify
3. `task-definition-template.json` - Template for ECS task definition (backend only)

#### Easy Setup (Recommended)

We've included helper scripts to make deployment easier:

1. Configure your environment variables:
   ```bash
   # Edit .env.deploy with your AWS account information
   cp .env.deploy.example .env.deploy
   nano .env.deploy
   ```

2. Load the environment variables (for backend deployment):
   ```bash
   source load-env.sh
   ```

3. Generate your task definition file (for backend):
   ```bash
   ./generate-task-definition.sh
   ```

4. Deploy your application:
   - For backend:
     ```bash
     ./rebuild-backend.sh
     ```
   - For frontend:
     ```bash
     ./rebuild-frontend.sh
     # You'll be prompted to enter a commit message
     ```

### Frontend Deployment with AWS Amplify

The frontend is deployed using AWS Amplify, which provides continuous deployment from your Git repository:

1. Initial Amplify Setup:
   - Connect your repository to AWS Amplify through the AWS console
   - Set up environment variables in the Amplify console, including:
     - `NEXT_PUBLIC_API_URL` pointing to your backend load balancer

2. To deploy frontend updates:
   ```bash
   # Run the deployment script
   ./rebuild-frontend.sh
   ```

3. The script will:
   - Show you which files have been modified
   - Prompt for a commit message
   - Commit and push changes to your GitHub repository
   - Amplify will automatically detect the push and start a new build

4. Monitor the deployment in the AWS Amplify Console:
   ```bash
   # Open the AWS Console in your browser for details
   aws amplify get-app --app-id $AMPLIFY_APP_ID
   ```

5. Once deployed, your frontend will connect to the backend through the load balancer.

### Backend Deployment with AWS ECS

To deploy updates to the backend:

1. Make your code changes
2. Run the deployment script:
   ```bash
   chmod +x rebuild-backend.sh
   ./rebuild-backend.sh
   ```

3. Monitor the deployment:
   ```bash
   aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME
   ```

---

## 📌 API Routes

### **Upload an Image & Process with Operator**
**`POST /operators/:operator`**
```sh
curl -X POST -F "file=@image.jpg" http://localhost:3001/operators/sobel
```
Response:
```json
{
  "status": "success",
  "output": "/uploads/output-image.jpg"
}
```

> Note: The API is protected by a client-side rate limit that allows only one image upload per 30 seconds.

---

## 🛠️ Tech Stack
- **Frontend**: Next.js, React, Tailwind CSS
- **Backend**: Node.js, Express.js, Multer (file uploads)
- **Image Processing**: OpenCV (C++), CMake
- **Database**: Local storage (future implementation for S3 support)
- **Security**: Client-side rate limiting for DDoS protection
- **Containerization**: Docker, Docker Compose

---

## 📜 License
MIT License.

---

## ✨ Contributors
- **Kailin Xing** - Developer
- **Kailin Xing** - Maintainer

PRs & Issues are welcome! 🚀