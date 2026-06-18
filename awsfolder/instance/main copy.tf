#create web server ec2 
resource "aws_instance" "web_server2" {
  count = 0
  ami     = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.tier2_public_sg]
  user_data = file("${path.module}/user_data.sh")
  key_name = var.key_pair_name

  tags = var.mandatory_tags

}

#create web server ec2 
resource "aws_instance" "web_server" {
  count = 0
  ami     = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.tier2_public_sg]
  user_data = file("${path.module}/user_data.sh")
  key_name = var.key_pair_name

  tags = {
    Name = "web_server"
  }

}

#create prometheus ec2 
resource "aws_instance" "prometheus" {
  count = 0
  ami     = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.prometheus_sg]
  user_data = file("${path.module}/prometheus.sh")
  key_name = var.key_pair_name

  tags = {
    Name = "prometheus"
  }

}

#create grafana ec2 
resource "aws_instance" "grafana" {
  count = 0
  ami     = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.grafana_sg]
  user_data = file("${path.module}/grafana.sh")
  key_name = var.key_pair_name

  tags = {
    Name = "grafana"
  }

}

resource "aws_instance" "jenkin_server" {
  count = 1
  ami     = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.tier2_public_sg]
  user_data = file("${path.module}/jenkin.sh")
  key_name = var.key_pair_name

  tags = {
    Name = "jenkins_server"
  }
}