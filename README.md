# EdgeDetectr

EdgeDetectr is a full-stack web application for applying image processing operators (Sobel, Prewitt, Roberts, etc.) to uploaded images. The project consists of:

- **Frontend**: A Next.js application for user interaction.
- **Backend**: An Express.js server that handles image uploads and processing.
- **Operators**: A C++ module using OpenCV to apply edge detection operators.
- **Deployment**: Fully containerized using Docker.

## 🎥 Demo
https://github.com/user-attachments/assets/47b9ef04-d53f-4267-a9d8-3cf7a6b2d60c


## 🚀 Features
- Upload an image via the frontend.
- Choose an edge detection operator (Sobel, Prewitt, Roberts, etc.).
- Process the image on the backend using C++ and OpenCV.
- Retrieve and display the processed image.
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

---

## 🛠️ Tech Stack
- **Frontend**: Next.js, React, Tailwind CSS
- **Backend**: Node.js, Express.js, Multer (file uploads)
- **Image Processing**: OpenCV (C++), CMake
- **Database**: Local storage (future implementation for S3 support)
- **Containerization**: Docker, Docker Compose

---

## 📜 License
MIT License.

---

## ✨ Contributors
- **Kailin Xing** - Developer
- **Kailin Xing** - Maintainer

PRs & Issues are welcome! 🚀

## Deployment

### Environment Setup

To deploy the application, you'll need to set up environment variables with your AWS account information:

```bash
export AWS_ACCOUNT_ID=your_aws_account_id
export AWS_REGION=your_aws_region
export CLUSTER_NAME=edgedetectr-cluster
export SERVICE_NAME=edgedetectr-backend
export REPOSITORY_NAME=edgedetectr-backend
```

### Using the Deployment Templates

This repository includes template files for deploying to AWS ECS:

1. `rebuild-backend-template.sh` - Template for building and deploying the backend
2. `task-definition-template.json` - Template for ECS task definition

#### Easy Setup (Recommended)

We've included helper scripts to make deployment easier:

1. Configure your environment variables:
   ```bash
   # Edit .env.deploy with your AWS account information
   cp .env.deploy.example .env.deploy
   nano .env.deploy
   ```

2. Load the environment variables:
   ```bash
   source load-env.sh
   ```

3. Generate your task definition file:
   ```bash
   ./generate-task-definition.sh
   ```

4. Deploy your application:
   ```bash
   ./rebuild-backend.sh
   ```

#### Manual Setup

If you prefer, you can still manually create your deployment files:

1. Make a copy of each template file without the `-template` suffix
2. Replace the placeholder values with your actual AWS account information
3. Add these files to your `.gitignore` to keep them private

### Deploying Updates

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
