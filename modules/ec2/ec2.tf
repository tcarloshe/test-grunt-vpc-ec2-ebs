# Data source para AMI latest Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_ids[0] # En la primera subnet privada
  iam_instance_profile = var.iam_instance_profile

  tags = merge(local.common_tags, { Name = "WebInstance" })

  root_block_device {
    tags = merge(local.common_tags, { Name = "WebRootVolume" })
  }
}

resource "aws_ebs_volume" "extra" {
  count = length(var.ebs_sizes)

  availability_zone = aws_instance.web.availability_zone
  size              = var.ebs_sizes[count.index]
  type              = "gp3"
  encrypted         = true

  tags = merge(local.common_tags, { Name = "ExtraVolume${count.index + 1}" })
}

resource "aws_volume_attachment" "extra_attach" {
  count = length(var.ebs_sizes)

  # Nombres recomendados: /dev/xvdf, /dev/xvdg, /dev/xvdh, etc.
  device_name = "/dev/xvd${element(["f", "g", "h", "i", "j", "k"], count.index)}"

  volume_id   = aws_ebs_volume.extra[count.index].id
  instance_id = aws_instance.web.id

  # Opcional pero recomendado: fuerza detach si ya está attached (útil en destroy)
  force_detach = true

  # Espera a que el volumen esté disponible antes de adjuntar
  depends_on = [aws_ebs_volume.extra, aws_instance.web]
}