resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "terraform_demo_key" {
  key_name   = "ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "terraform_demo_jupyter" {
  ami           = var.ami
  instance_type = "t2.micro"
  user_data     = <<-EOF
            #!/bin/bash
            sudo amazon-linux-extras install docker -y > /mylog.log
            sudo service docker start
            sudo docker stop "spark-notebook" 2> /dev/null

            sudo docker run --name "spark-notebook" \
                -d \
                -p 80:8888 \
                -v /home/ec2-user:/home/jovyan \
                -e JUPYTER_ENABLE_LAB=yes \
                -e JUPYTER_TOKEN=admin \
                -e GRANT_SUDO=yes \
                --user root \
                jupyter/all-spark-notebook:016833b15ceb
        EOF
  provisioner "local-exec" {
    command = "echo ${self.public_ip}"
  }
  subnet_id              = aws_subnet.terraform_demo_subnet.id
  depends_on             = [aws_internet_gateway.terraform_demo_gateway]
  vpc_security_group_ids = [aws_security_group.terraform_demo_security_group.id]
  key_name               = aws_key_pair.terraform_demo_key.key_name
  tags = {
    Name = var.main_env_tag
  }
}