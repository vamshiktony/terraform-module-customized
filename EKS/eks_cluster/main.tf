provider aws {
  region = "ap-south-1"
}





resource "aws_eks_cluster" "example" {
  name     = "harshad"
  version  =  1.19
  role_arn = aws_iam_role.example.arn

  vpc_config {
#    cluster_security_group_id =  "sg-08c51f47131704c99" 
    security_group_ids = [ "sg-08c51f47131704c99" ]
    endpoint_private_access   = false
    endpoint_public_access    = true
    subnet_ids = [ "subnet-b76364df", "subnet-168aff5a" ]
  }


#security_group_ids
  
#  vpc_config {
#          + cluster_security_group_id = (known after apply)
#          + endpoint_private_access   = false
#          + endpoint_public_access    = true
#          + public_access_cidrs       = (known after apply)
#          + subnet_ids                = [
#              + "subnet-168aff5a",
#              + "subnet-b76364df",
#            ]
#          + vpc_id                    = (known after apply)
#        }


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
##    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.example-AmazonEKSServicePolicy,
  ]
}

########################### creating roles and assume_roles for eks cluster###################################

resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
#resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#  role       = aws_iam_role.example.name
#}



##################### attaching eks service policy###############################
resource "aws_iam_role_policy_attachment" "example-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.example.name
}
#arn:aws:iam::aws:policy/AmazonEKSServicePolicy


output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}
