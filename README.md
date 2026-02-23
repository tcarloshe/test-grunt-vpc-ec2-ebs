# tfbasics
# Terraform AWS Workshop

Guía práctica paso a paso para provisionar infraestructura en AWS usando **Terraform**, siguiendo mejores prácticas de DevOps, seguridad y Git.

**Objetivo del ejercicio**  
Crear un VPC con 2 subnets privadas, una instancia EC2 t2.micro (Amazon Linux) con 2 volúmenes EBS adicionales, todo en la región us-east-1, con tags consistentes y enfoque en seguridad.

**Características clave**  
- VPC con subnets privadas (sin acceso público directo)  
- EC2 en subnet privada + IAM Role (no credenciales hardcodeadas)  
- Volúmenes EBS gp3 adjuntados  
- Tags obligatorios en todos los recursos: Name, environment, created_by, creation_date, project  
- Código 100% modular (archivos separados: providers, variables, vpc, ec2, iam, outputs)  
- Uso de data sources para AMI dinámica  
- **Mejor práctica IAM**: permisos otorgados mediante **grupo** en lugar de attach directo a usuario

## Requisitos previos

- Cuenta AWS (free tier suficiente)  
- Git, VSCode + extensión Remote-WSL, WSL con Ubuntu  
- Terraform ≥ 1.5 instalado en WSL  
- AWS CLI configurado en WSL

## Comando utiles Terraform
- terraform init
- terraform validate
- terraform fmt
- terraform plan
- terraform apply
- terraform destroy
- terraform output
- **PRO**:  terraform plan -out=tfplan && terraform apply tfplan

## Comandos Git
- git add README.md 
- git commit -m "Updated README"
- git push
- git push origin
