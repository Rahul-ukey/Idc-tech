resource "aws_instance" "kubectl-server" {
  ami                         = "ami-008fe2fc65df48dac"
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-1.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  key_name = "rahulkey"
  tags = {
    Name = "master-node"
  }
}

resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "pc-node-group"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  instance_types  = [ "t2.medium" ]

  remote_access { 
    ec2_ssh_key =  "rahulkey"
    source_security_group_ids = [aws_security_group.allow_tls. id]
  }
  tags = {
    Name = "worker-node"
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.ElasticLoadBalancingFullAccess,
    aws_iam_role_policy_attachment.AmazonEC2FullAccess,
    aws_iam_role_policy_attachment.AmazonEC2ReadOnlyAccess
  ]
}