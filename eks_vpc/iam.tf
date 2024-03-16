/*# IAM.tf

# Define IAM OIDC identity provider
resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url            = module.eks.cluster_oidc_issuer_url
  client_id_list = ["sts.amazonaws.com"]
}

# Map IAM roles to Kubernetes RBAC roles
resource "kubernetes_cluster_role_binding" "eks_admin" {
  metadata {
    name = "eks-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

# Define IAM role and policy for worker nodes
resource "aws_iam_role" "eks_worker_nodes_role" {
  name               = "eks-worker-nodes-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "eks_worker_nodes_policy_attachment" {
  name       = "eks-worker-nodes-policy-attachment"
  roles      = [aws_iam_role.eks_worker_nodes_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
*/