module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true

  self_managed_node_groups = {
    hello-k8s-ng = {
      ami_type      = "AL2023_x86_64_STANDARD"
      instance_type = "t3.medium"

      min_size = 1
      max_size = 2
      desired_size = 1
      
    }
  }

  tags = {
    Project = var.project
  }
}