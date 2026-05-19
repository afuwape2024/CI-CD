#create web server ec2 
resource "aws_instance" "web_server" {
  count = 0
  ami     = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.tier2_public_sg]
  user_data = file("${path.module}/user_data.sh")

  tags = var.mandatory_tags

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