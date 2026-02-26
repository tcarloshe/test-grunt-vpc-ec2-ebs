output "orphan_volume_ids" {
  description = "IDs of orphan EBS volumes"
  value       = aws_ebs_volume.orphan[*].id
}

output "orphan_volume_arns" {
  description = "ARNs of orphan EBS volumes"
  value       = aws_ebs_volume.orphan[*].arn
}

output "orphan_volume_details" {
  description = "Details of orphan EBS volumes"
  value = {
    volume_ids = aws_ebs_volume.orphan[*].id
    volume_sizes = aws_ebs_volume.orphan[*].size
    encryption_status = aws_ebs_volume.orphan[*].encrypted
  }
}
