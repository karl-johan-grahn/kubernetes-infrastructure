locals {
  cluster_name                 = "mytempsite.tk"
  master_autoscaling_group_ids = [aws_autoscaling_group.master-eu-west-1a-masters-mytempsite-tk.id]
  master_security_group_ids    = [aws_security_group.masters-mytempsite-tk.id]
  masters_role_arn             = aws_iam_role.masters-mytempsite-tk.arn
  masters_role_name            = aws_iam_role.masters-mytempsite-tk.name
  node_autoscaling_group_ids   = [aws_autoscaling_group.nodes-mytempsite-tk.id]
  node_security_group_ids      = [aws_security_group.nodes-mytempsite-tk.id]
  node_subnet_ids              = [aws_subnet.eu-west-1a-mytempsite-tk.id]
  nodes_role_arn               = aws_iam_role.nodes-mytempsite-tk.arn
  nodes_role_name              = aws_iam_role.nodes-mytempsite-tk.name
  region                       = "eu-west-1"
  route_table_public_id        = aws_route_table.mytempsite-tk.id
  subnet_eu-west-1a_id         = aws_subnet.eu-west-1a-mytempsite-tk.id
  vpc_cidr_block               = aws_vpc.mytempsite-tk.cidr_block
  vpc_id                       = aws_vpc.mytempsite-tk.id
}

output "cluster_name" {
  value = "mytempsite.tk"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.master-eu-west-1a-masters-mytempsite-tk.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-mytempsite-tk.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-mytempsite-tk.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-mytempsite-tk.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-mytempsite-tk.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-mytempsite-tk.id]
}

output "node_subnet_ids" {
  value = [aws_subnet.eu-west-1a-mytempsite-tk.id]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-mytempsite-tk.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-mytempsite-tk.name
}

output "region" {
  value = "eu-west-1"
}

output "route_table_public_id" {
  value = aws_route_table.mytempsite-tk.id
}

output "subnet_eu-west-1a_id" {
  value = aws_subnet.eu-west-1a-mytempsite-tk.id
}

output "vpc_cidr_block" {
  value = aws_vpc.mytempsite-tk.cidr_block
}

output "vpc_id" {
  value = aws_vpc.mytempsite-tk.id
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_autoscaling_attachment" "master-eu-west-1a-masters-mytempsite-tk" {
  autoscaling_group_name = aws_autoscaling_group.master-eu-west-1a-masters-mytempsite-tk.id
  elb                    = aws_elb.api-mytempsite-tk.id
}

resource "aws_autoscaling_group" "master-eu-west-1a-masters-mytempsite-tk" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.master-eu-west-1a-masters-mytempsite-tk.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "master-eu-west-1a.masters.mytempsite.tk"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "mytempsite.tk"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "master-eu-west-1a.masters.mytempsite.tk"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-eu-west-1a"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-eu-west-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/mytempsite.tk"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.eu-west-1a-mytempsite-tk.id]
}

resource "aws_autoscaling_group" "nodes-mytempsite-tk" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.nodes-mytempsite-tk.id
  max_size             = 2
  metrics_granularity  = "1Minute"
  min_size             = 2
  name                 = "nodes.mytempsite.tk"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "mytempsite.tk"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes.mytempsite.tk"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes"
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes"
  }
  tag {
    key                 = "kubernetes.io/cluster/mytempsite.tk"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.eu-west-1a-mytempsite-tk.id]
}

resource "aws_ebs_volume" "a-etcd-events-mytempsite-tk" {
  availability_zone = "eu-west-1a"
  encrypted         = false
  size              = 20
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "a.etcd-events.mytempsite.tk"
    "k8s.io/etcd/events"                  = "a/a"
    "k8s.io/role/master"                  = "1"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
  type = "gp2"
}

resource "aws_ebs_volume" "a-etcd-main-mytempsite-tk" {
  availability_zone = "eu-west-1a"
  encrypted         = false
  size              = 20
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "a.etcd-main.mytempsite.tk"
    "k8s.io/etcd/main"                    = "a/a"
    "k8s.io/role/master"                  = "1"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
  type = "gp2"
}

resource "aws_elb" "api-mytempsite-tk" {
  cross_zone_load_balancing = false
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "SSL:443"
    timeout             = 5
    unhealthy_threshold = 2
  }
  idle_timeout = 300
  listener {
    instance_port      = 443
    instance_protocol  = "TCP"
    lb_port            = 443
    lb_protocol        = "TCP"
    ssl_certificate_id = ""
  }
  name            = "api-mytempsite-tk-d3ul6b"
  security_groups = [aws_security_group.api-elb-mytempsite-tk.id]
  subnets         = [aws_subnet.eu-west-1a-mytempsite-tk.id]
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "api.mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-mytempsite-tk" {
  name = "masters.mytempsite.tk"
  role = aws_iam_role.masters-mytempsite-tk.name
}

resource "aws_iam_instance_profile" "nodes-mytempsite-tk" {
  name = "nodes.mytempsite.tk"
  role = aws_iam_role.nodes-mytempsite-tk.name
}

resource "aws_iam_role_policy" "masters-mytempsite-tk" {
  name   = "masters.mytempsite.tk"
  policy = file("${path.module}/data/aws_iam_role_policy_masters.mytempsite.tk_policy")
  role   = aws_iam_role.masters-mytempsite-tk.name
}

resource "aws_iam_role_policy" "nodes-mytempsite-tk" {
  name   = "nodes.mytempsite.tk"
  policy = file("${path.module}/data/aws_iam_role_policy_nodes.mytempsite.tk_policy")
  role   = aws_iam_role.nodes-mytempsite-tk.name
}

resource "aws_iam_role" "masters-mytempsite-tk" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_masters.mytempsite.tk_policy")
  name               = "masters.mytempsite.tk"
}

resource "aws_iam_role" "nodes-mytempsite-tk" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_nodes.mytempsite.tk_policy")
  name               = "nodes.mytempsite.tk"
}

resource "aws_internet_gateway" "mytempsite-tk" {
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
  vpc_id = aws_vpc.mytempsite-tk.id
}

resource "aws_key_pair" "kubernetes-mytempsite-tk-36d900fbbe554a6def9a62115cb8ab62" {
  key_name   = "kubernetes.mytempsite.tk-36:d9:00:fb:be:55:4a:6d:ef:9a:62:11:5c:b8:ab:62"
  public_key = file("${path.module}/data/aws_key_pair_kubernetes.mytempsite.tk-36d900fbbe554a6def9a62115cb8ab62_public_key")
}

resource "aws_launch_configuration" "master-eu-west-1a-masters-mytempsite-tk" {
  associate_public_ip_address = true
  enable_monitoring           = false
  iam_instance_profile        = aws_iam_instance_profile.masters-mytempsite-tk.id
  image_id                    = "ami-0127d62154efde733"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.kubernetes-mytempsite-tk-36d900fbbe554a6def9a62115cb8ab62.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "master-eu-west-1a.masters.mytempsite.tk-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.masters-mytempsite-tk.id]
  user_data       = file("${path.module}/data/aws_launch_configuration_master-eu-west-1a.masters.mytempsite.tk_user_data")
}

resource "aws_launch_configuration" "nodes-mytempsite-tk" {
  associate_public_ip_address = true
  enable_monitoring           = false
  iam_instance_profile        = aws_iam_instance_profile.nodes-mytempsite-tk.id
  image_id                    = "ami-0127d62154efde733"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.kubernetes-mytempsite-tk-36d900fbbe554a6def9a62115cb8ab62.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "nodes.mytempsite.tk-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.nodes-mytempsite-tk.id]
  user_data       = file("${path.module}/data/aws_launch_configuration_nodes.mytempsite.tk_user_data")
}

resource "aws_route53_record" "api-mytempsite-tk" {
  alias {
    evaluate_target_health = false
    name                   = aws_elb.api-mytempsite-tk.dns_name
    zone_id                = aws_elb.api-mytempsite-tk.zone_id
  }
  name    = "api.mytempsite.tk"
  type    = "A"
  zone_id = "/hostedzone/Z06148838B9CC2ZY453E"
}

resource "aws_route_table_association" "eu-west-1a-mytempsite-tk" {
  route_table_id = aws_route_table.mytempsite-tk.id
  subnet_id      = aws_subnet.eu-west-1a-mytempsite-tk.id
}

resource "aws_route_table" "mytempsite-tk" {
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
    "kubernetes.io/kops/role"             = "public"
  }
  vpc_id = aws_vpc.mytempsite-tk.id
}

resource "aws_route" "route-0-0-0-0--0" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mytempsite-tk.id
  route_table_id         = aws_route_table.mytempsite-tk.id
}

resource "aws_security_group_rule" "all-master-to-master" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-mytempsite-tk.id
  source_security_group_id = aws_security_group.masters-mytempsite-tk.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "all-master-to-node" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-mytempsite-tk.id
  source_security_group_id = aws_security_group.masters-mytempsite-tk.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "all-node-to-node" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-mytempsite-tk.id
  source_security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "api-elb-egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.api-elb-mytempsite-tk.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.api-elb-mytempsite-tk.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "https-elb-to-master" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-mytempsite-tk.id
  source_security_group_id = aws_security_group.api-elb-mytempsite-tk.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3
  protocol          = "icmp"
  security_group_id = aws_security_group.api-elb-mytempsite-tk.id
  to_port           = 4
  type              = "ingress"
}

resource "aws_security_group_rule" "master-egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.masters-mytempsite-tk.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "node-egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  from_port                = 1
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-mytempsite-tk.id
  source_security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port                  = 2379
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  from_port                = 2382
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-mytempsite-tk.id
  source_security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port                  = 4000
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  from_port                = 4003
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-mytempsite-tk.id
  source_security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  from_port                = 1
  protocol                 = "udp"
  security_group_id        = aws_security_group.masters-mytempsite-tk.id
  source_security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-mytempsite-tk.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-mytempsite-tk.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group" "api-elb-mytempsite-tk" {
  description = "Security group for api ELB"
  name        = "api-elb.mytempsite.tk"
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "api-elb.mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
  vpc_id = aws_vpc.mytempsite-tk.id
}

resource "aws_security_group" "masters-mytempsite-tk" {
  description = "Security group for masters"
  name        = "masters.mytempsite.tk"
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "masters.mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
  vpc_id = aws_vpc.mytempsite-tk.id
}

resource "aws_security_group" "nodes-mytempsite-tk" {
  description = "Security group for nodes"
  name        = "nodes.mytempsite.tk"
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "nodes.mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
  vpc_id = aws_vpc.mytempsite-tk.id
}

resource "aws_subnet" "eu-west-1a-mytempsite-tk" {
  availability_zone = "eu-west-1a"
  cidr_block        = "172.20.32.0/19"
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "eu-west-1a.mytempsite.tk"
    "SubnetType"                          = "Public"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
    "kubernetes.io/role/elb"              = "1"
  }
  vpc_id = aws_vpc.mytempsite-tk.id
}

resource "aws_vpc_dhcp_options_association" "mytempsite-tk" {
  dhcp_options_id = aws_vpc_dhcp_options.mytempsite-tk.id
  vpc_id          = aws_vpc.mytempsite-tk.id
}

resource "aws_vpc_dhcp_options" "mytempsite-tk" {
  domain_name         = "eu-west-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
}

resource "aws_vpc" "mytempsite-tk" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "KubernetesCluster"                   = "mytempsite.tk"
    "Name"                                = "mytempsite.tk"
    "kubernetes.io/cluster/mytempsite.tk" = "owned"
  }
}

terraform {
  required_version = ">= 0.12.0"
}
