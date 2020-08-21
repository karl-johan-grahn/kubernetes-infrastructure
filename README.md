# Infrastructure as Code
This repository uses [Terraform](https://www.terraform.io/) to provision
Kubernetes infrastructure via code.

## Terraform backend
Use a remote backend instead of local to store the state file.

A separate Terraform script will be used to create the needed S3
bucket. It should only be run once to create the infrastructure
needed to enable remote backend storage:

```
cd remote_state
terraform init
terraform apply
```


Some options for running Kubernetes on AWS:
1. Set up everything manually via for example
[Kubernete the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
which is good from a learning perspective, but not practical or economical from a maintenance perspective
2. Use Amazon Elastic Kubernetes Service (Amazon EKS),
a fully managed Kubernetes control plane
3. Use Kops
4. Use Terraform

With EKS, pods share the same network as the VPC that the cluster was created in.
VPC security groups have to be used to restrict access to the pods.
EKS supports Calico which allows us to isolate network segments.

Comparing Kops with EKS:
* Kops has a lower cost of entry: Compared to EKS it is easier and quicker to
create the cluster.
* EKS has a lower maintenance cost: Compared to Kops, it requires less work
to keep master nodes up to date.


* Got domain at freenom.com
* Installed `kops`
* Install `kubectl`

## Future work
For production purposes, evaluate these options:
* [Pulumi](https://www.pulumi.com/) could be an alternative to Terraform
