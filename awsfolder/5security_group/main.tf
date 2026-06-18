#create the security group for tier2 public subnet servers
resource "aws_security_group" "tier2_public_sg" {
  name        = "tier2_sg"
  description = "Security group for tier2 public subnet servers"
  vpc_id      = var.tier2_vpc
  tags = {
    Name = "tier2_public_sg"
  }
}

# Ingress rule for HTTP (port 80) from anywhere on the internet
resource "aws_security_group_rule" "http_access" {
  type              = "ingress"
  security_group_id = aws_security_group.tier2_public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  description       = "Allow HTTP from the internet"
}

# Ingress rule for HTTPS (port 443) from anywhere on the internet
resource "aws_security_group_rule" "allow_tls_ipv4" {
  type              = "ingress"
  security_group_id = aws_security_group.tier2_public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow HTTPS from the internet"
}

# Ingress rule for SSH (port 22) from anywhere
resource "aws_security_group_rule" "ssh_access" {
  type              = "ingress"
  security_group_id = aws_security_group.tier2_public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "Allow SSH from specific IP range"
}

# Ingress rule for application traffic (port 8080)
resource "aws_security_group_rule" "tcp_access" {
  type              = "ingress"
  security_group_id = aws_security_group.tier2_public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  description       = "Allow TCP 8080 from the internet"
}

# Egress rule to allow all outbound traffic
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.tier2_public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow all outbound traffic"
}


#$=========================================================================
#create the security group for tier2 private subnet servers
resource "aws_security_group" "tier2_private_sg" {
  name        = "tier2_private_sg"
  description = "Security group for tier2 private subnet servers"
  vpc_id      = var.tier2_vpc
  tags = {
    Name = "tier2_private_sg"
  }
}   

resource "aws_security_group_rule" "ssh_access_private" {
  type              = "ingress"
  security_group_id = aws_security_group.tier2_private_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "Allow SSH from specific IP range"
}

# # Ingress rule for HTTPS (TCP port 443) from within the VPC CIDR
# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.tier2_private_sg.id
#   cidr_ipv4         = aws_vpc.tier2_vpc.cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

#$=========================================================================
#$=========================================================================

resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus-security-group"
  description = "Security group for Prometheus server"
  vpc_id      = var.tier2_vpc

  # Prometheus UI
  ingress {
    description = "Prometheus Web UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"

    # Restrict to your office/VPN IP in production
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Access (Optional)
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Replace with your IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prometheus-sg"
  }
}

#$=========================================================================
#$=========================================================================
resource "aws_security_group" "grafana_sg" {
  name        = "grafana-sg"
  description = "Security Group for Grafana"
  vpc_id      = var.tier2_vpc

  ingress {
    description = "Grafana Web UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"

    # Replace with your public IP for security
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Restrict to your trusted CIDR in production
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grafana-sg"
  }
}

#$=========================================================================
#$=========================================================================

resource "aws_security_group" "sonaque_sg" {
  name        = "sonaque-security-group"
  description = "Security group for Prometheus server"
  vpc_id      = var.tier2_vpc

  # Prometheus UI
  ingress {
    description = "sonaque Web UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"

    # Restrict to your office/VPN IP in production
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Access (Optional)
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Replace with your IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sonaque_sg"
  }
}

#$=========================================================================
#$=========================================================================

resource "aws_security_group" "nexus_sg" {
  name        = "nexus-security-group"
  description = "Security group for Prometheus server"
  vpc_id      = var.tier2_vpc

  # Prometheus UI
  ingress {
    description = "nexus Web UI"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"

    # Restrict to your office/VPN IP in production
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Access (Optional)
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Replace with your IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nexus_sg"
  }
}