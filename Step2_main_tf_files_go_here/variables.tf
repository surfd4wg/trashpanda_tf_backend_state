variable "client" {
  type        = string
  description = "Client name, used as a prefix for resource names"
}

variable AWS_REGION {
  description = "the region you want to stand this up in"
  default = ""
}

variable AWS_AZ {
  description = "the availability zone you want this in"
  default = ""
}

variable INSTANCE_TYPE {
  description = "the instance type you want"
  default = ""
}

variable "access_key" {
  description = "Access Key to AWS account"
  default     = "-replace access key-"
}

variable "secret_key" {
  description = "Secret Key to AWS account"
  default     = "----------replace secret key------------"
}

variable "DOCKER_VERSION" {
  description = "Docker version to install in the jump host"
  default = "latest"
}

variable "ANSIBLE_VERSION" {
  description = "Ansible version to install in the jump host"
  default = "latest"
}

variable "CLUSTERNAME" {
  description = "what you will call your kubernetes cluster"
  default = ""
}

variable "CQ_ALIAS" {
  description = "your hacker alias"
  default = ""
}

variable "CQ_USERNAME" {
  description = "your login email address"
  default = ""
}

variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "~/.ssh/<your public key file>.pub"
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "~/.ssh/<your private key file>.pem"
}

variable "project_name" {
  description = "<your org name> terraform CEQUENCE aws DEMO"
  default     = ""
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ec2-user"
}

variable "myname" {
  description = "Default Name tag for AWS Resources"
  default     = "AMAZONlinux2"
}

variable "mydept" {
  description = "Default Deapartment tag for AWS Resources"
  default     = ""
}

variable "myorg" {
  description = "Default Organization tag for AWS Resources"
  default     = ""
}

variable "mystack" {
  description = "Default Stack tag for AWS Resources"
  default     = ""
}

variable "myenv" {
  description = "Default Env tag for AWS Resources"
  default     = ""
}

variable "ami_id" {
  description = "Random id generator"
  default     = 1234567890
}

variable "instance_count" {
  description = "Number of instances to launch"
  default = 1
}


