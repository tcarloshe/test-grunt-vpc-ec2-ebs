variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, stg, prod) for resource naming"
  type        = string
  default     = "dev"
}

variable "availability_zones" {
  description = "Availability zones for the region"
  type        = list(string)
}

variable "volume_sizes" {
  description = "Sizes of EBS volumes in GB (1, 2, 3, 4)"
  type        = list(number)
  default     = [1, 2, 3, 4]
  
  validation {
    condition     = length(var.volume_sizes) == 4
    error_message = "Must provide exactly 4 volume sizes."
  }
}

variable "owner" {
  description = "Owner tag for orphan volumes"
  type        = string
  default     = "Tom"
}

variable "email" {
  description = "Email tag for orphan volumes"
  type        = string
  default     = "tom@ejemplo.com"
}
