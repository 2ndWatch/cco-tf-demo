# https://www.itprotoday.com/sql-server/sql-server-tcp-and-udp-ports
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Windows SQL Server 2012 Application Security Group."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Internet Control Message Protocol"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "SQL Server HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "SQL Server HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "SQL Server"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "SQL Server Named Instances"
    from_port   = 1433
    to_port     = 1433
    protocol    = "udp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Dedicated Admin Connection"
    from_port   = 1434
    to_port     = 1434
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "SQL Server Analysis Services"
    from_port   = 2383
    to_port     = 2383
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "SQL Server Analysis Services Named Instances"
    from_port   = 2382
    to_port     = 2382
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "SQL Server Integration Services; Transact-SQL Debugger"
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Solarwinds"
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["10.133.200.63/32"]
  }
}

# https://docs.oracle.com/cd/B19306_01/install.102/b15660/app_port.htm
resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "Oracle Database Security Group."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Internet Control Message Protocol"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description     = "SSH (bastion)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "Oracle SQL *Net Listener; Oracle Data Guard"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Connection Manager"
    from_port   = 1630
    to_port     = 1630
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Management Agent"
    from_port   = 1830
    to_port     = 1849
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Enterprise Manager Database Console (HTTP Port)"
    from_port   = 5500
    to_port     = 5519
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Enterprise Manager Database Console (RMI Port)"
    from_port   = 5520
    to_port     = 5539
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Enterprise Manager Database Console (JMS Port)"
    from_port   = 5540
    to_port     = 5559
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle iSQL *Plus (HTTP Port)"
    from_port   = 5560
    to_port     = 5579
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle iSQL *Plus (RMI Port)"
    from_port   = 5580
    to_port     = 5599
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle iSQL *Plus (JMS Port)"
    from_port   = 5600
    to_port     = 5619
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Ultra Search (HTTP Port)"
    from_port   = 5620
    to_port     = 5639
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Ultra Search (RMI Port)"
    from_port   = 5640
    to_port     = 5659
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Ultra Search (JMS Port)"
    from_port   = 5660
    to_port     = 5679
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Ultra Search (JMS Port)"
    from_port   = 5660
    to_port     = 5679
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Real Application Cluster"
    from_port   = 61000
    to_port     = 61300
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Real Application Cluster"
    from_port   = 11000
    to_port     = 26000
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Clusterware"
    from_port   = 49896
    to_port     = 49896
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Cluster Synchronization Service (CSS)"
    from_port   = 49895
    to_port     = 49895
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "Oracle Event Manager"
    from_port   = 49897
    to_port     = 49898
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "Solarwinds"
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["10.133.200.63/32"]
  }
}

resource "aws_security_group" "bastion" {
  #checkov:skip=CKV_AWS_24:Open SSH
  #checkov:skip=CKV_AWS_25:Open RDP
  name        = "bastion-sg"
  description = "Bastion Host Security Group."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "NTP"
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
