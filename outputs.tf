output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.private[*].id
}

output "ec2_id" {
  value = aws_instance.web.id
}

output "ebs_volume_ids" {
  value = aws_ebs_volume.extra[*].id
}