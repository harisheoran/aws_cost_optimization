resource "aws_instance" "test-ec2" {
    ami = var.ami
    instance_type = var.instance_type

    tags = {
      Name = var.ec2-name
    }
}