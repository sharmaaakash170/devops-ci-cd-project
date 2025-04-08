# 🚀 End-to-End DevOps CI/CD Project on AWS

This project demonstrates a full CI/CD pipeline for a **Python Flask** app deployed to **AWS EKS** using **Terraform**, **Helm**, **CodePipeline**, **CodeBuild**, and **ECR**.

---

## 🛠 Tech Stack

- **AWS EKS** – Managed Kubernetes Cluster
- **AWS ECR** – Docker image repository
- **AWS CodeBuild** – Build and deployment tool
- **AWS CodePipeline** – End-to-end CI/CD flow
- **Terraform** – Infrastructure as Code (IaC)
- **Helm** – Kubernetes package manager
- **Python Flask** – Web application
- **Docker** – Containerization

---

## 📂 Project Structure

```
devops-ci-cd-project/
│
├── app/
│   └── app.py                   # Flask app
│
├── Dockerfile                   # Docker config
│
├── buildspec.yml                # CodeBuild instructions
│
├── flask-app/
│   ├── Chart.yaml
│   └── templates/
│       └── deployment.yaml
│       └── service.yaml
│
├── terraform-infra/
│   ├── main.tf
│   ├── variables.tf
│   └── modules/
│       ├── vpc/
│       ├── eks/
│       ├── ecr/
│       ├── codebuild/
│       ├── codepipeline/
│       └── helm-charts/
│
├── aws-auth.yaml                # Auth config for EKS
└── README.md
```

---

## 🌐 Flask App Routes

| Route    | Response                                |
|----------|------------------------------------------|
| `/`      | "CiCd pipeline created successfully"     |
| `/hello` | "Hey, it is deployed successfully"       |
| `/time`  | Shows real-time current server time      |

---

## ✅ What’s Done

- Built a Flask App with 4 endpoints
- Dockerized the app and pushed to AWS ECR
- Created EKS cluster using Terraform
- Wrote Helm chart to deploy app
- Set up CodeBuild using `buildspec.yml`
- Connected GitHub repo to CodePipeline
- Used Terraform modules for clean infra setup
- Automatically deployed app to EKS
- Debugged and fixed auth, provider, and Helm issues
- Successfully exposed app using LoadBalancer service

---

## 🚀 Deployment Flow

1. **Provision Infrastructure**
   ```bash
   cd terraform-infra
   terraform init
   terraform apply --auto-approve
   ```

2. **Update kubeconfig**
   ```bash
   aws eks update-kubeconfig --name flask-eks-cluster --region us-east-1
   ```

3. **Push Docker Image (manual or via CodeBuild)**
   ```bash
   docker build -t flask-app .
   docker tag flask-app:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/flask-app:latest
   docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/flask-app:latest
   ```

4. **Deploy Using Helm**
   ```bash
   helm upgrade --install flask-app ./helm-chart
   ```

5. **Verify Kubernetes Deployment**
   ```bash
   kubectl get pods
   kubectl get svc
   ```

6. **Access the Application**
   ```bash
   http://<loadbalancer-url>:5000
   ```

---

## 🧹 Destroy Resources

```bash
cd terraform-infra
terraform destroy --auto-approve
```

---

## 🙋‍♂️ Author

**Aakash Sharma**  
🔗 [GitHub](https://github.com/sharmaaakash170)  
🔗 [LinkedIn](https://www.linkedin.com/in/aakash-sharma-8937b81aa/)

---

## 📌 Hashtags (for Community)

`#DevOps #AWS #CI/CD #Terraform #Helm #Flask #Python #Kubernetes #EKS #Docker #CodePipeline #CodeBuild`
