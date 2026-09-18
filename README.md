# 🚀 RoboShop - End-to-End DevSecOps Deployment Platform

An end-to-end **DevOps and DevSecOps implementation** for deploying the RoboShop microservices application using Docker, Terraform, Kubernetes, Helm, GitHub Actions, Prometheus, Grafana, SonarQube, and Trivy.

This project demonstrates a complete production-style software delivery lifecycle including:

* Infrastructure as Code (AWS EKS, ALB, EBS)
* Containerization
* CI/CD Automation
* Manual Approval Gates
* Kubernetes Orchestration
* Helm Deployments
* DNS and Service Discovery
* Monitoring and Observability
* Shift-Left Security
* SAST
* Container Image Vulnerability Scanning

---

# 📌 Project Overview

RoboShop is a microservices-based e-commerce application consisting of multiple frontend, backend, database, cache, and messaging services.

This project focuses on implementing an end-to-end DevOps and DevSecOps workflow where infrastructure provisioning, application deployment, security, and monitoring are fully automated using modern cloud-native tools.

---

# ✨ Key Features

* 🐳 Docker Containerization
* 🏗️ Terraform Infrastructure as Code
* ☸️ Kubernetes Orchestration
* 💽 AWS EBS CSI & Dynamic gp3 Storage
* ⚖️ AWS ALB Ingress Controller
* ⛵ Helm-based Kubernetes Deployments
* 🔄 GitHub Actions CI/CD
* 🛑 Manual Approval Gate
* 🔐 SonarQube SAST
* 🛡️ Trivy Image Scanning
* 🔍 Shift-Left Security
* 🌐 DNS and Service Discovery
* 📊 Prometheus Monitoring
* 📈 Grafana Dashboards

---

# 🏗️ End-to-End Architecture

```text
[Developer] -> [GitHub Repository] -> [GitHub Actions CI/CD]
  │
  ├── [Code Checkout]
  ├── [SonarQube SAST Scan (Shift Left)] -> [Quality Gate Check]
  ├── [Docker Build] -> [Trivy Image Scan (Shift Left)]
  ├── [Terraform Validation]
  ├── [Manual Approval Gate]
  └── [Terraform Apply]
        │
        ▼
   [AWS EKS Cluster]
        │
        ▼
   [Helm Deploy]
        │
        ▼
   [RoboShop Microservices]
        │
        ▼
   [Prometheus Monitoring] -> [Grafana Dashboards]

```

---

# 📂 Repository Structure

```text
roboshop-deployment/
├── .github/
│   └── workflows/          # CI/CD and Destroy pipeline configurations
├── docker/                 # Dockerfiles for RoboShop microservices
├── helm-roboshop/          # Helm charts for Kubernetes deployment
├── infra/                  # Terraform configurations (EKS, VPC, Route53)
├── scripts/                # Deployment and automation scripts
├── compose.yaml            # Local multi-container Docker Compose setup
└── README.md

```

---

# 🐳 Docker Containerization

Each RoboShop microservice is containerized using Docker.

The application consists of services such as:

* Frontend
* Catalogue
* User
* Cart
* Shipping
* Payment
* MongoDB
* MySQL
* Redis
* RabbitMQ

Docker provides:

* Consistent application environments
* Service isolation
* Portability
* Reproducible builds
* Simplified deployments

---

# 🚀 Running the Application with Docker Compose

## Prerequisites

Install:

* Docker
* Docker Compose

Verify the installation:

```bash
docker --version
docker compose version

```

## Clone the Repository

```bash
git clone https://github.com/ruthvikk1214/roboshop-deployment.git
cd roboshop-deployment

```

## Build and Start

```bash
docker compose up -d --build

```

Verify containers:

```bash
docker ps

```

View logs:

```bash
docker compose logs

```

Stop the application:

```bash
docker compose down

```

---

# 🌐 DNS and Service Discovery

Microservices require reliable communication between services. Instead of hardcoding IP addresses, the project uses DNS-based service discovery.

## Docker DNS

Docker Compose automatically provides DNS resolution between services using service names.

Example: `Cart Service -> http://catalogue:8080` | `Redis -> redis:6379`

## Kubernetes DNS

Kubernetes provides internal DNS-based service discovery. Services can communicate using Kubernetes Service names:

```text
Frontend -> catalogue-service -> Catalogue Pods

```

This enables dynamic communication between microservices without relying on static Pod IP addresses.

---

# 🏗️ Infrastructure Provisioning with Terraform

Terraform is used to provision and manage infrastructure using Infrastructure as Code.

Benefits include:

* Repeatable infrastructure
* Version-controlled infrastructure
* Automated provisioning
* Consistent environments
* Reduced manual configuration

## Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy

```

---

# ☸️ Kubernetes Deployment

RoboShop is deployed on Kubernetes for container orchestration. This deployment incorporates critical AWS add-ons for production readiness:

* **AWS EBS CSI Driver:** Dynamically provisions `gp3` storage volumes for stateful applications like Prometheus.
* **AWS Load Balancer Controller:** Automatically provisions an Application Load Balancer (ALB) to handle external traffic routing to the frontend.

---

# ⛵ Helm Deployment

Helm is used to manage and deploy Kubernetes applications. The Helm charts are located in `helm-roboshop/`.

Install Application:

```bash
helm install roboshop .

```

Check releases:

```bash
helm list

```

Check pods:

```bash
kubectl get pods

```

---

# 🔄 CI/CD Pipeline

GitHub Actions is used to automate the CI/CD workflow.

The pipeline automates:

* Code checkout
* Code validation
* Security scanning
* Docker image building
* Container image scanning
* Terraform validation
* Infrastructure deployment
* Manual approval
* Kubernetes deployment
* Helm deployment

---

# 🔐 Shift-Left Security

This project follows the **Shift-Left Security** approach. Security checks are performed early in the software development lifecycle instead of waiting until after deployment.

```text
Code -> Security Scan (SAST) -> Build -> Security Scan (Container) -> Deploy

```

This helps identify vulnerabilities earlier and reduces the risk of deploying insecure applications.

---

# 🔍 SAST - SonarQube

SonarQube is integrated into the CI pipeline for Static Application Security Testing (SAST).

SonarQube analyzes source code and helps identify:

* Security vulnerabilities
* Bugs
* Code smells
* Security hotspots
* Technical debt

---

# 🚦 SonarQube Quality Gate

After the SonarQube analysis, the pipeline checks the Quality Gate:

```text
Code -> SonarQube Scan -> Quality Gate
  ├── PASS -> Continue Pipeline
  └── FAIL -> Stop Pipeline

```

---

# 🛡️ Trivy Image Scanning

Trivy is used to scan Docker images for vulnerabilities:

```text
Docker Build -> Docker Image -> Trivy Scan
  ├── PASS -> Continue Pipeline
  └── FAIL -> Stop Pipeline

```

The scan verifies operating system vulnerabilities, dependency vulnerabilities, and critical/high CVEs.

---

# 🛑 Manual Approval Gate

A manual approval gate is included before critical deployment stages. This provides human validation before infrastructure or production changes are applied.

Benefits:

* Prevent accidental deployments
* Human validation for critical changes
* Additional production safety
* Controlled infrastructure changes

---

# 📊 Monitoring and Observability

The project uses a lightweight, highly efficient monitoring stack:

* **Prometheus:** Metrics collection and alerting rules evaluation.
* **Grafana:** Data visualization and alert notification routing.

## Collected Metrics:

* CPU and Memory usage
* Pod health and Node metrics
* Application metrics and Resource utilization

## Monitoring Architecture:

```text
Kubernetes Cluster (Nodes & Pods) -> Prometheus Metrics Collection -> Grafana Dashboards

```

---

# 🛠️ Technology Stack

| Category | Technology |
| --- | --- |
| Version Control | Git, GitHub |
| CI/CD | GitHub Actions |
| Manual Gate | GitHub Environments / Manual Approval |
| Containerization | Docker |
| Container Orchestration | Kubernetes |
| Kubernetes Package Manager | Helm |
| Cloud Provider | AWS |
| Infrastructure as Code | Terraform |
| Ingress Controller | AWS Load Balancer Controller |
| Storage Provisioning | AWS EBS CSI Driver (gp3) |
| Service Discovery | Docker DNS, Kubernetes DNS |
| Monitoring | Prometheus |
| Visualization | Grafana |
| SAST | SonarQube |
| Vulnerability Scanning | Trivy |
| Security Strategy | Shift-Left Security |
| Web Server | Nginx |
| Database | MongoDB, MySQL |
| Cache | Redis |
| Messaging | RabbitMQ |
| Operating System | Linux / Amazon Linux 2 |

---

# 🗺️ Project Roadmap

## Phase 1 - Containerization

* [x] Containerize RoboShop microservices
* [x] Configure Docker networking
* [x] Implement Docker Compose
* [x] Implement DNS-based service discovery

## Phase 2 - Infrastructure as Code

* [x] Provision infrastructure using Terraform
* [x] Automate infrastructure deployment

## Phase 3 - Kubernetes

* [x] Deploy application on Kubernetes
* [x] Configure AWS EBS CSI Driver for persistent storage
* [x] Configure AWS Load Balancer Controller for ingress
* [x] Manage deployments using Helm

## Phase 4 - CI/CD

* [x] Implement GitHub Actions
* [x] Automate infrastructure workflows
* [x] Add Manual Approval Gate

## Phase 5 - Monitoring

* [x] Deploy Prometheus
* [x] Configure Grafana
* [x] Monitor Kubernetes workloads

## Phase 6 - DevSecOps

* [x] Integrate SonarQube SAST
* [x] Configure Quality Gates
* [x] Integrate Trivy Image Scanning
* [x] Implement Shift-Left Security

---

# 👨‍💻 Author

**Ruthvik**

DevOps Engineer

GitHub: [https://github.com/ruthvikk1214](https://github.com/ruthvikk1214?utm_source=gemini)

---

# ⭐ Project Summary

This project demonstrates an end-to-end production-style DevOps and DevSecOps implementation for a microservices application.

The complete solution covers:

* 🐳 Docker
* 🏗️ Terraform (VPC, EKS, Node Groups)
* ☸️ Kubernetes (Ingress, StatefulSets, Deployments)
* ⛵ Helm
* 🌐 DNS and Service Discovery
* 🔄 CI/CD
* 🛑 Manual Approval Gates
* 🔐 SAST
* 🔍 Shift-Left Security
* 🛡️ Trivy Image Scanning
* 📊 Prometheus
* 📈 Grafana