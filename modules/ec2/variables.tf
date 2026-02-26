variable "environment" {
  description = "Environment name (dev, stg, prod) for resource naming"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "Lista de IDs de subnets privadas"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "Nombre del instance profile para EC2"
  type        = string
}
variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
  type        = string
}

variable "ebs_sizes" {
  description = "Tamaños de volúmenes EBS en GB"
  default     = [8, 8, 5, 5, 8]
  type        = list(number)
}

variable "tags" {
  description = "Tags comunes"
  default = {
    environment   = "dev"
    created_by    = "Tom"
    creation_date = "2026-02-24"
    project       = "Terraform WorkShop"
  }
  type = map(string)
}

variable "repository_url" {
  description = "URL completa del repositorio Git que contiene esta configuración"
  type        = string
  default     = "https://github.com/tu-usuario/terraform-aws-workshop"
}

variable "repository_path" {
  description = "Ruta relativa dentro del repositorio (usar '.' si es la raíz)"
  type        = string
  default     = "."
}

variable "managed_by" {
  description = "Herramienta o método que gestiona este recurso"
  type        = string
  default     = "terragrunt"
}

variable "cost_center" {
  description = "Centro de costos o WBS que absorbe el costo"
  type        = string
  default     = "2-6660023302-8"
}
variable "app_owner" {
  description = "Nombre o identificador del dueño/responsable de la aplicación"
  type        = string
  default     = "Finance"
}

variable "app_owner_email" {
  description = "Correo electrónico del dueño/responsable de la aplicación"
  type        = string
  default     = "finance_dl@ejemplo.com"
}

variable "creator_email" {
  description = "Correo de la persona que creó o mantiene esta infraestructura"
  type        = string
  default     = "Tom@ejemplo.com"
}

variable "tickets" {
  description = "Identificador(es) de tickets relacionados (Jira, ServiceNow, etc.)"
  type        = string
  default     = "JIRA-1234 CHANGE-5678"
}