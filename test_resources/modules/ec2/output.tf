output "ebs_volume_id" {
  value = aws_instance.test-ec2.root_block_device.0.volume_id
}