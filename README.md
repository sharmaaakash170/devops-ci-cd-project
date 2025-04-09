# Flask CI/CD Pipeline on AWS using EKS, CodePipeline, CodeBuild, ECR, Terraform & Helm

This project demonstrates a complete CI/CD pipeline for a Flask application using AWS services and DevOps tools.

---

## 🚀 Tech Stack Used

- **AWS EKS (Elastic Kubernetes Service)**
- **AWS CodePipeline**
- **AWS CodeBuild**
- **AWS ECR (Elastic Container Registry)**
- **Terraform** (for Infrastructure as Code)
- **Helm** (Kubernetes package manager)
- **Python Flask** (Web framework)

---

## 🔄 Workflow

1. Push code to GitHub.
2. CodePipeline triggers the build.
3. CodeBuild fetches the code, builds the Docker image, and pushes it to ECR.
4. Helm chart is applied to EKS to deploy the application.

---

## 📂 Project Structure

```
terraform-infra/
├── main.tf
├── modules/
│   ├── vpc/
│   ├── eks/
│   ├── ecr/
│   ├── codebuild/
│   └── codepipeline/
flask-app/
├── Chart.yaml
├── templates/
│   └── deployment.yaml
│   └── service.yaml
app/
├── app.py
├── requirements.txt
buildspec.yml
aws-auth.yaml
```

---

## 🐍 Flask App Endpoints

- `/` → "CiCd pipeline created successfully"
- `/time` → Returns current time

---

## ❗Common Error Faced

```bash
error: You must be logged in to the server (the server has asked for the client to provide credentials)
```

### ✅ Solution

Run the following command **locally** (not inside CodeBuild):

```bash
kubectl apply -f aws-auth.yaml
```

---

## 🔁 Data Flow Diagram

Below is a simple visual representation of the CI/CD pipeline:

![ChatGPT_Image_Apr_8_2025_10_26_07_PM](https://github.com/user-attachments/assets/496cbc08-3966-4bb2-b18f-c54bfc9e9a0b)


---

## 🧠 Learnings

- Deploying Flask on Kubernetes using Helm.
- Managing infrastructure with Terraform.
- Setting up CI/CD pipeline with AWS services.
- Troubleshooting real-world DevOps issues.

---

## 📎 Author Links

- GitHub: [github.com/sharmaaakash170](https://github.com/sharmaaakash170)
- LinkedIn: [linkedin.com/in/aakash-sharma-8937b81aa](https://www.linkedin.com/in/aakash-sharma-8937b81aa/)
