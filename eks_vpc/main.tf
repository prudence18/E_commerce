module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eCommerce"  # VPC name tag
  cidr = var.vpc_cidr
  azs  = ["us-east-1a", "us-east-1b"]  # Adjust AZs as needed for high availability

  public_subnets  = var.public_subnet_cidrs  # Subnets for public resources
  private_subnets = var.private_subnet_cidrs  # Subnets for private resources

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Optional: VPC endpoint for S3
  #enable_s3_endpoint = true

  # Tags for VPC and subnets
  tags = {
    Name = "eCommerce-vpc"
  }

  public_subnet_tags = {
    Name = "public-subnet"
  }

  private_subnet_tags = {
    Name = "private-subnet"
  }

  # Map public IP on launch for instances in public subnets
  map_public_ip_on_launch = true
}

# Creating security group for inbound & outbound traffic
resource "aws_security_group" "custom_security_group" {
  name        = "custom-security-group"
  description = "Inbound & Outbound traffic for custom-security-group"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value["description"]
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  # Security group tags
  tags = {
    Name = "security-group"
  }
}


