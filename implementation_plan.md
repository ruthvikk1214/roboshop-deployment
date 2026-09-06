# Implementation Plan: CI/CD Pipeline with GitHub Actions

## Goal
Create a GitHub Actions workflow to automate security scanning and infrastructure provisioning. The workflow will enforce a strict sequence: Image Scanning -> Infra Scanning -> Infra Plan -> Infra Apply.

## User Review Required
> [!IMPORTANT]
> - **AWS Credentials**: For the Terraform Plan and Apply jobs to work in GitHub Actions, you will need to add your AWS credentials as GitHub Secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`), or we can configure OIDC for secure passwordless authentication. Which do you prefer?
> - **Docker Images**: Your repo has multiple microservices (`cart`, `catalogue`, `user`, etc.). Do you want the pipeline to *build* these images first and then scan them, or just scan the local Dockerfiles/source code using Trivy `fs` mode? The proposed plan uses a matrix strategy to build and scan the image for each service.
> - **Terraform Variables**: The pipeline needs to pass `hosted_zone_id` to Terraform. We will pull this from a GitHub Secret (`HOSTED_ZONE_ID`).

## Open Questions
> [!NOTE]
> - Are you okay with automatically running `terraform apply` on pushes to the `main` branch, or would you prefer it to require a manual trigger or only run on Pull Request merges?

## Proposed Changes
---
### .github/workflows
#### [NEW] ci.yml
Creates the GitHub Actions pipeline with the following jobs:

1. **`image-scan`**: 
   - Uses a matrix to iterate through `[cart, catalogue, frontend, payment, shipping, user]`.
   - Builds the Docker image locally.
   - Uses `aquasecurity/trivy-action` to scan the built image for vulnerabilities (CRITICAL and HIGH).

2. **`terraform-checkov`**: 
   - `needs: image-scan`
   - Uses `bridgecrewio/checkov-action` to scan the `infra/` directory for security misconfigurations.

3. **`terraform-plan`**: 
   - `needs: terraform-checkov`
   - Configures AWS credentials.
   - Runs `terraform init`, `terraform fmt -check`, `terraform validate`, and `terraform plan`.

4. **`terraform-apply`**:
   - `needs: terraform-plan`
   - Only runs if the branch is `main`.
   - Runs `terraform apply -auto-approve`.

## Verification Plan
- Commit the `.github/workflows/ci.yml` file.
- Push to GitHub and observe the Actions tab to ensure the workflow triggers.
- Verify that a failure in the Trivy scan or Checkov scan prevents Terraform from running.
