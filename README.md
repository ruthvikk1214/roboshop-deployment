# 🚀 RoboShop - End-to-End DevSecOps Deployment Platform

An end-to-end **DevOps and DevSecOps implementation** for deploying the RoboShop microservices application using Docker, Terraform, Kubernetes, Helm, GitHub Actions, Prometheus, Grafana, EFK Stack, SonarQube, and Trivy.

This project demonstrates a complete production-style software delivery lifecycle including:

* Infrastructure as Code
* Containerization
* CI/CD Automation
* Manual Approval Gates
* Kubernetes Orchestration
* Helm Deployments
* DNS and Service Discovery
* Monitoring and Observability
* Centralized Logging
* Shift-Left Security
* SAST
* Container Image Vulnerability Scanning

---

# 📌 Project Overview

RoboShop is a microservices-based e-commerce application consisting of multiple frontend, backend, database, cache, and messaging services.

This project focuses on implementing an end-to-end DevOps and DevSecOps workflow where infrastructure, application deployment, security, monitoring, and logging are automated using modern cloud-native tools.

---

# ✨ Key Features

* 🐳 Docker Containerization
* 🏗️ Terraform Infrastructure as Code
* ☸️ Kubernetes Orchestration
* ⛵ Helm-based Kubernetes Deployments
* 🔄 GitHub Actions CI/CD
* 🛑 Manual Approval Gate
* 🔐 SonarQube SAST
* 🛡️ Trivy Image Scanning
* 🔍 Shift-Left Security
* 🌐 DNS and Service Discovery
* 📊 Prometheus Monitoring
* 📈 Grafana Dashboards
* 📜 EFK Centralized Logging

---

# 🏗️ End-to-End Architecture

```text
                         Developer
                             │
                             ▼
                       GitHub Repository
                             │
                             ▼
                     GitHub Actions CI/CD
                             │
                             ▼
                       Code Checkout
                             │
                             ▼
                   SonarQube SAST Scan
                       (Shift Left)
                             │
                             ▼
                     Quality Gate Check
                             │
                             ▼
                       Docker Build
                             │
                             ▼
                    Trivy Image Scan
                       (Shift Left)
                             │
                             ▼
                    Terraform Validation
                             │
                             ▼
                   Manual Approval Gate
                             │
                             ▼
                 Terraform Infrastructure
                             │
                             ▼
                    Kubernetes Cluster
                             │
                             ▼
                       Helm Deploy
                             │
                             ▼
                  RoboShop Microservices
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
         Prometheus                      EFK Stack
         Monitoring                   Centralized Logs
              │                             │
              ▼                             ▼
           Grafana                        Kibana
          Dashboards                 Log Visualization
```

---

# 📂 Repository Structure

```text
roboshop-deployment
│
├── .github/
│   └── workflows/
│       └── CI/CD pipeline configurations
│
├── docker/
│   └── Dockerfiles for RoboShop services
│
├── helm-roboshop/
│   └── Helm charts for Kubernetes deployment
│
├── infra/
│   └── Terraform infrastructure configurations
│
├── scripts/
│   └── Deployment and automation scripts
│
├── compose.yaml
│
├── implementation_plan.md
│
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

Microservices require reliable communication between services.

Instead of hardcoding IP addresses, the project uses DNS-based service discovery.

## Docker DNS

Docker Compose automatically provides DNS resolution between services.

Services communicate using service names.

Example:

```text
catalogue
redis
mongodb
mysql
rabbitmq
```

For example:

```text
Cart Service
     │
     ▼
http://catalogue:8080
```

Redis:

```text
redis:6379
```

MongoDB:

```text
mongodb
```

---

# ☸️ Kubernetes DNS

Kubernetes provides internal DNS-based service discovery.

Services can communicate using Kubernetes Service names.

Example:

```text
catalogue
catalogue.default
catalogue.default.svc.cluster.local
```

A Kubernetes service provides a stable DNS endpoint even when Pods are recreated.

Example:

```text
Frontend
    │
    ▼
catalogue-service
    │
    ▼
Catalogue Pods
```

This enables dynamic communication between microservices without relying on Pod IP addresses.

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

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Preview changes:

```bash
terraform plan
```

Apply infrastructure:

```bash
terraform apply
```

Destroy infrastructure:

```bash
terraform destroy
```

---

# ☸️ Kubernetes Deployment

RoboShop is deployed on Kubernetes for container orchestration.

Kubernetes provides:

* Container orchestration
* Self-healing
* Service discovery
* Scaling
* Load balancing
* Rolling updates

---

# ⛵ Helm Deployment

Helm is used to manage and deploy Kubernetes applications.

The Helm charts are located in:

```text
helm-roboshop/
```

## Install Application

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

Upgrade deployment:

```bash
helm upgrade roboshop .
```

Uninstall deployment:

```bash
helm uninstall roboshop
```

Helm simplifies Kubernetes deployments by packaging related Kubernetes resources into reusable charts.

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

This project follows the **Shift-Left Security** approach.

Security checks are performed early in the software development lifecycle instead of waiting until after deployment.

```text
Traditional Approach

Code
 │
 ▼
Build
 │
 ▼
Deploy
 │
 ▼
Security Scan


Shift-Left Approach

Code
 │
 ▼
Security Scan
 │
 ▼
Build
 │
 ▼
Security Scan
 │
 ▼
Deploy
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
* Code quality issues
* Technical debt

---

# 🚦 SonarQube Quality Gate

After the SonarQube analysis, the pipeline checks the Quality Gate.

```text
Code
 │
 ▼
SonarQube Scan
 │
 ▼
Quality Gate
 │
 ├── PASS ────► Continue Pipeline
 │
 └── FAIL ────► Stop Pipeline
```

This prevents low-quality or insecure code from progressing through the pipeline.

---

# 🛡️ Trivy Image Scanning

Trivy is used to scan Docker images for vulnerabilities.

The scan checks for:

* Operating system vulnerabilities
* Dependency vulnerabilities
* Known CVEs
* Critical vulnerabilities
* High severity vulnerabilities

Example workflow:

```text
Docker Build
     │
     ▼
Docker Image
     │
     ▼
Trivy Scan
     │
     ├── PASS ────► Continue Pipeline
     │
     └── FAIL ────► Stop Pipeline
```

This prevents vulnerable container images from being deployed.

---

# 🔐 DevSecOps Security Workflow

```text
Developer
    │
    ▼
Git Push
    │
    ▼
GitHub Actions
    │
    ▼
Code Checkout
    │
    ▼
SonarQube SAST
    │
    ▼
Quality Gate
    │
    ▼
Docker Build
    │
    ▼
Trivy Image Scan
    │
    ▼
Terraform Validation
    │
    ▼
Manual Approval Gate
    │
    ▼
Terraform Apply
    │
    ▼
Kubernetes
    │
    ▼
Helm Deployment
```

---

# 🛑 Manual Approval Gate

A manual approval gate is included before critical deployment stages.

This provides human validation before infrastructure or production changes are applied.

```text
CI Pipeline
     │
     ▼
Security Checks
     │
     ▼
Build
     │
     ▼
Infrastructure Validation
     │
     ▼
Manual Approval
     │
     ├── Approved ────► Deploy
     │
     └── Rejected ────► Stop Pipeline
```

Benefits:

* Prevent accidental deployments
* Human validation for critical changes
* Additional production safety
* Controlled infrastructure changes

---

# 📊 Monitoring and Observability

The project uses:

* Prometheus
* Grafana

---

# 📈 Prometheus Monitoring

Prometheus is used to collect and store metrics from the infrastructure and Kubernetes workloads.

Metrics include:

* CPU usage
* Memory usage
* Pod health
* Container metrics
* Node metrics
* Application metrics
* Resource utilization

Prometheus stores metrics as time-series data.

---

# 📊 Grafana Dashboards

Grafana is used to visualize metrics collected by Prometheus.

Grafana provides dashboards for:

* Kubernetes cluster health
* Node utilization
* Pod utilization
* CPU usage
* Memory usage
* Infrastructure metrics
* Application performance

---

# 📊 Monitoring Architecture

```text
                   Kubernetes Cluster
                           │
                           ▼
            ┌──────────────────────────────┐
            │                              │
            ▼                              ▼
          Nodes                            Pods
            │                              │
            └──────────────┬───────────────┘
                           │
                           ▼
                      Prometheus
                    Metrics Collection
                           │
                           ▼
                       Grafana
                     Dashboards
```

---

# 📜 Centralized Logging - EFK Stack

The project uses the EFK Stack for centralized logging.

EFK consists of:

* Elasticsearch
* Fluent Bit
* Kibana

---

# 📥 Fluent Bit

Fluent Bit collects logs from Kubernetes containers and Pods.

Responsibilities include:

* Collect container logs
* Collect Kubernetes logs
* Parse logs
* Forward logs to Elasticsearch

---

# 🔎 Elasticsearch

Elasticsearch is used for:

* Centralized log storage
* Log indexing
* Log searching
* Log retention

---

# 📊 Kibana

Kibana provides log visualization and analysis.

Kibana can be used for:

* Searching logs
* Troubleshooting issues
* Visualizing application logs
* Analyzing errors
* Investigating incidents

---

# 📜 EFK Architecture

```text
                Kubernetes Pods
                      │
                      ▼
               Application Logs
                      │
                      ▼
                  Fluent Bit
                Log Collection
                      │
                      ▼
                Elasticsearch
                  Log Storage
                      │
                      ▼
                    Kibana
              Log Visualization
```

---

# 📊 Observability Stack

| Tool          | Purpose                  |
| ------------- | ------------------------ |
| Prometheus    | Metrics collection       |
| Grafana       | Metrics visualization    |
| Fluent Bit    | Log collection           |
| Elasticsearch | Log storage and indexing |
| Kibana        | Log visualization        |

---

# 🛠️ Technology Stack

| Category                   | Technology                            |
| -------------------------- | ------------------------------------- |
| Version Control            | Git, GitHub                           |
| CI/CD                      | GitHub Actions                        |
| Manual Gate                | GitHub Environments / Manual Approval |
| Containerization           | Docker                                |
| Container Orchestration    | Kubernetes                            |
| Kubernetes Package Manager | Helm                                  |
| Service Discovery          | Docker DNS, Kubernetes DNS            |
| Infrastructure as Code     | Terraform                             |
| Cloud Provider             | AWS                                   |
| Monitoring                 | Prometheus                            |
| Visualization              | Grafana                               |
| Centralized Logging        | EFK Stack                             |
| Log Collection             | Fluent Bit                            |
| Log Storage                | Elasticsearch                         |
| Log Visualization          | Kibana                                |
| SAST                       | SonarQube                             |
| Vulnerability Scanning     | Trivy                                 |
| Security Strategy          | Shift-Left Security                   |
| Web Server                 | Nginx                                 |
| Database                   | MongoDB, MySQL                        |
| Cache                      | Redis                                 |
| Messaging                  | RabbitMQ                              |
| Operating System           | Linux                                 |

---

# 🧠 Key DevOps and DevSecOps Concepts

This project demonstrates hands-on experience with:

## DevOps

* Docker
* Docker Compose
* Terraform
* AWS
* Kubernetes
* Helm
* CI/CD
* GitHub Actions
* DNS
* Service Discovery
* Monitoring
* Observability
* Centralized Logging

## DevSecOps

* Shift-Left Security
* SAST
* SonarQube
* Quality Gates
* Trivy
* Container Image Scanning
* Vulnerability Detection
* CI/CD Security Gates
* Manual Approval Gates

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
* [x] Configure Kubernetes Services
* [x] Configure Kubernetes DNS
* [x] Manage deployments using Helm

## Phase 4 - CI/CD

* [x] Implement GitHub Actions
* [x] Automate infrastructure workflows
* [x] Add Manual Approval Gate

## Phase 5 - Monitoring

* [x] Deploy Prometheus
* [x] Configure Grafana
* [x] Monitor Kubernetes workloads

## Phase 6 - Centralized Logging

* [x] Deploy EFK Stack
* [x] Configure Fluent Bit
* [x] Configure Elasticsearch
* [x] Configure Kibana
* [x] Centralize Kubernetes logs

## Phase 7 - DevSecOps

* [x] Integrate SonarQube SAST
* [x] Configure Quality Gates
* [x] Integrate Trivy Image Scanning
* [x] Implement Shift-Left Security

---

# 🎯 Complete Project Workflow

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions CI/CD
    │
    ├── Code Checkout
    │
    ├── SAST Scan
    │      │
    │      ▼
    │   SonarQube
    │
    ├── Quality Gate
    │
    ├── Docker Build
    │
    ├── Trivy Image Scan
    │
    ├── Terraform Validation
    │
    ├── Manual Approval
    │
    └── Terraform Apply
            │
            ▼
         AWS
            │
            ▼
      Kubernetes
            │
            ▼
         Helm
            │
            ▼
    RoboShop Application
            │
            ├─────────────────┐
            │                 │
            ▼                 ▼
       Prometheus          Fluent Bit
            │                 │
            ▼                 ▼
        Grafana        Elasticsearch
                              │
                              ▼
                            Kibana
```

---

# 👨‍💻 Author

**Ruthvik**

DevOps Engineer

GitHub: https://github.com/ruthvikk1214

---

# ⭐ Project Summary

This project demonstrates an end-to-end production-style DevOps and DevSecOps implementation for a microservices application.

The complete solution covers:

* 🐳 Docker
* 🏗️ Terraform
* ☸️ Kubernetes
* ⛵ Helm
* 🌐 DNS and Service Discovery
* 🔄 CI/CD
* 🛑 Manual Approval Gates
* 🔐 SAST
* 🔍 Shift-Left Security
* 🛡️ Trivy Image Scanning
* 📊 Prometheus
* 📈 Grafana
* 📜 EFK Centralized Logging

The project demonstrates how modern DevOps and DevSecOps practices can be combined to automate infrastructure provisioning, application deployment, security validation, monitoring, and centralized logging.
