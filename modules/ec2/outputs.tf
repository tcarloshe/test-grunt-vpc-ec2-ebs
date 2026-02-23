output "ec2_id" {
  value = aws_instance.web.id
}

output "ebs_volume_ids" {
  value = aws_ebs_volume.extra[*].id
}