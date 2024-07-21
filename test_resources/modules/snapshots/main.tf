resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = var.volume_id

  tags = {
    Name = "test snapshot"
  }
}