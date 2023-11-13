resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu-22-04.id
  instance_type = "t2.small"

  tags = {
    Name = "example-instance"
  }
}

data "aws_ami" "ubuntu-22-04" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-jammy-22.04-amd64-server*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
