# hello-k8s-infra

Terraform infrastructure for the [hello-k8s](https://github.com/brkcvlk/hello-k8s) project. Provisions an EKS cluster on AWS with ArgoCD for GitOps-based deployments.

## Architecture(Simplified)

![Architecture](assets/architecture(simplified).svg)

**Stack:**
- EKS cluster (Kubernetes version: 1.33 (use 1.34 instead of 1.33)) with self-managed node group (AL2023, t3.medium)
- VPC with 2x public / 2x private subnets across 2 AZs
- Single NAT Gateway for private subnet egress
- ArgoCD for GitOps deployments
- S3 remote state with file locking

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- An AWS account with permissions to create EKS, VPC, IAM, and S3 resources

## Getting Started

### 1. Bootstrap (first time only)

Creates the S3 bucket used to store Terraform state.

```bash
make bootstrap
```

### 2. Configure backend

```bash
cp bootstrap/backend_hcl.example backend.hcl
# Fill in the bucket and table names from bootstrap output
```

### 3. Initialize and deploy

```bash
make init
make plan
make apply
```

### 4. Connect to the cluster

```bash
aws eks update-kubeconfig --region eu-central-1 --name hello-k8s --profile terraform
kubectl get nodes
```

### 5. Deploy the application

```bash
kubectl apply -f https://raw.githubusercontent.com/brkcvlk/hello-k8s/main/manifests/argocd-app.yml
```
> [!NOTE]
> ArgoCD will sync the application automatically from the [hello-k8s](https://github.com/brkcvlk/hello-k8s) repository.

## Makefile Commands

| Command | Description |
|---|---|
| `make bootstrap` | Create S3 state bucket (run once) |
| `make init` | Initialize Terraform backend |
| `make plan` | Preview infrastructure changes |
| `make apply` | Apply infrastructure changes |
| `make destroy` | Destroy all infra resources |
| `make bootstrap-destroy` | Destroy bootstrap resources |
| `make fmt` | Format all Terraform files |
| `make fmt-check` | Check formatting (used in CI) |
| `make validate` | Validate Terraform configuration |

## CI/CD

| Event | Workflow | Action |
|---|---|---|
| Pull request to `main` | `infra-plan.yml` | fmt check >> validate >> plan (posted as PR comment) |
| Push to `main` | `infra-apply.yml` | fmt check >> validate >> plan >> apply |

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `AWS_REGION` | AWS region (e.g. `eu-central-1`) |
| `BACKEND_HCL` | Full contents of `backend.hcl` |

## Teardown

```bash
make destroy          # Remove EKS, VPC, and all infra
make bootstrap-destroy # Remove S3 state bucket (destructive!)
```

> [!WARNING]
> Run `make destroy` before `make bootstrap-destroy` to avoid losing Terraform state.