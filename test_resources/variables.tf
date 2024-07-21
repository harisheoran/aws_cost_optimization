variable "ec2-name" {
  type = string
  description = "Name of EC2"
}

variable "ami" {
  type = string
  description = "AMI of ec2"
}

variable "instance_type" {
  type = string
  description = "Instance type of EC2"
}

variable "volume_id" {
  type = string
}