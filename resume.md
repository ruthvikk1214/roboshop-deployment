# Ruthvekh Kadudhuri
ruthvekhkadudhuri@gmail.com | +91 9000442265 | linkedin://ruthvekh-kadudhuri | [github.com/ruthvikk1214](https://github.com/ruthvikk1214) | Hyderabad, India

---

Cloud & DevOps Engineer with 3 years of experience specializing in AWS infrastructure design, CI/CD pipeline architecture, and automating software delivery pipelines. Proven track record of managing 800+ servers, achieving 99.9% uptime, and implementing Infrastructure as Code (IaC) and DevSecOps practices to streamline deployment operations. Expert in Docker containerization, Kubernetes orchestration on Amazon EKS, and building secure, scalable microservices architectures. Experienced in Agile/Scrum environments with a strong focus on observability, incident management, and cloud cost optimization.

## EXPERIENCE

**Kyndryl Solutions Private Limited** **08/2023 – Present**
*Cloud & DevOps Engineer* *Hyderabad, India*
- Managed and optimized over 800 Linux (RHEL, Ubuntu) servers across development, staging, and production environments, maintaining a 99.9% system uptime rate and meeting strict SLA/SLO targets.
- Authored modular Terraform (HCL) configurations and Ansible playbooks to automate the provisioning of cloud networks, compute resources, and multi-AZ environments for 100+ workloads, reducing manual provisioning times by 60%.
- Engineered and optimized Jenkins and GitLab CI/CD pipelines to automate builds, testing, security checks, and container deployments, cutting delivery times by 80% (from hours to minutes).
- Provisioned and maintained production-grade Amazon EKS clusters using eksctl and Helm Charts, configuring resource limits, namespaces, and managed node groups to host scalable containerized microservice workloads.
- Integrated AWS CloudWatch, Prometheus, and Grafana dashboards for centralized monitoring, customized metrics, and real-time alerting, which reduced the mean time to resolution (MTTR) for incidents by 40%.
- Developed Python and Bash/Shell automation scripts for log analysis, infrastructure health checks, deployment orchestration, and automated incident triage, reducing repetitive manual tasks by 50%.
- Hardened AWS environments by enforcing DevSecOps best practices including the principle of least privilege using fine-grained IAM roles, container image vulnerability scanning, routine system patching, and compliance audits.
- Collaborated within cross-functional Agile/Scrum teams to resolve 50+ monthly production incidents, performing root cause analysis and maintaining a 98%+ SLA compliance rate across incident management workflows.

## KEY PROJECTS

**RoboShop Kubernetes Deployment (Amazon EKS)** [GitHub Repository](https://github.com/ruthvikk1214/k8-roboshop)
- Orchestrated the deployment of a 10-tier microservices application (Node.js, Java, Python, MongoDB, MySQL, Redis, RabbitMQ) on Amazon EKS using declarative Kubernetes YAML manifests, Deployments, ReplicaSets, and Services.
- Configured ClusterIP Services for internal DNS-based service discovery and deployed an AWS Load Balancer (ALB/NLB) for secure, public-facing traffic routing to the Nginx frontend.
- Externalized application configurations using ConfigMaps, implemented Readiness, Liveness, and Startup Probes for zero-downtime rolling updates, and configured resource requests and limits for CPU and memory management.
- Debugged complex runtime failures (CrashLoopBackOff, ImagePullBackOff, DNS resolution issues) using kubectl, k9s, and container log analysis, developing a systematic troubleshooting workflow for Kubernetes production incidents.

**Roboshop Microservices Containerization (Docker)** [GitHub Repository](https://github.com/ruthvikk1214/roboshop-docker)
- Containerized a multi-tier application (10+ distinct components including Node.js, Python, and Java services) using Docker, guaranteeing environment parity from local development to production.
- Implemented multi-stage Docker builds and adopted minimal Alpine base images, reducing production image footprints by over 50% and eliminating build-time dependencies from final releases.
- Defined a custom bridge network within Docker Compose (YAML) to enable automatic DNS resolution and secure container-to-container communication using service names instead of static IPs.
- Debugged complex container runtime scenarios including Docker build cache invalidation, dependency startup sequencing, and environment variable injection using docker logs, docker exec, and curl.

**Automated Enterprise AWS Infrastructure (Terraform)** [GitHub Repository](https://github.com/ruthvikk1214/terraform)
- Authored reusable Terraform modules (HCL) to provision a secure VPC complete with public, private, and database subnets across multiple availability zones, with dynamic security groups using for_each loops.
- Configured Application Load Balancers (ALBs) integrated with Amazon Certificate Manager (ACM) for HTTPS/SSL/TLS termination and Route53 for private hosted zone DNS routing.
- Managed remote Terraform state file storage securely using AWS S3 backend and enforced state locking via DynamoDB, preventing concurrency conflicts and race conditions across team CI/CD pipelines.
- Implemented automated instance bootstrapping using Ansible via Terraform's terraform_data provisioner to dynamically configure application hosts post-provisioning, eliminating manual server setup.

## SKILLS

- **Cloud & Infrastructure:** AWS (EC2, S3, IAM, VPC, CloudWatch, EKS, Route53, ALB, ACM, CloudFormation, DynamoDB)
- **Infrastructure as Code & Configuration:** Terraform, Ansible, AWS CloudFormation
- **Containerization & Orchestration:** Docker, Docker Compose, Kubernetes, Amazon EKS, Helm, kubectl, k9s, eksctl
- **CI/CD & DevOps Tools:** Jenkins, GitLab CI/CD, GitHub Actions, Git, GitHub, ArgoCD, GitOps
- **Monitoring & Observability:** Prometheus, Grafana, AWS CloudWatch, Splunk, ELK Stack
- **Programming & Scripting:** Bash/Shell, Python, YAML, HCL
- **Security & Compliance:** DevSecOps, IAM Policies, Vulnerability Scanning, SSL/TLS, Compliance Auditing
- **Operating Systems:** Linux (RHEL, Ubuntu)
- **Methodologies:** Agile, Scrum, Incident Management, SLA/SLO Management, GitOps

## EDUCATION

**Neil Gogte Institute of Technology** **08/2019 – 05/2023**
*Bachelor of Engineering (B.E.) in Information Technology — CGPA: 7.3/10* *Hyderabad, India*

## CERTIFICATIONS

- Microsoft Certified: Azure Administrator Associate (AZ-104)
- AWS Certified: Cloud Practitioner

## AWARDS & LEADERSHIP

- **Spot Award:** Recognized at Kyndryl for outstanding technical support and swift resolution of critical production outages.
- **Onboarding Project Lead:** Directed environment provisioning and knowledge transfer for new team members, accelerating onboarding time by 30%.
- **Service Excellence Award:** Awarded for consistently maintaining a 98%+ SLA compliance rate and delivering high-quality automation scripts.
