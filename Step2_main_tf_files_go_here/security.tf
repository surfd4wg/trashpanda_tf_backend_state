resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        local.common_tags,

        tomap(
          {"Zoo" = "AWS Zoofarm"
	   "Name" = "nacl-${var.myname}-${random_id.server.hex}"
           "RESOURCE" = "security group"
          }
        )
        )

  #Allow All Out
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  #Allow All In
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_security_group" "allowall" {
  name        = "secgroup-${var.myname}-${random_id.server.hex}"
  description = "Allows All traffic"
  vpc_id      = aws_vpc.main.id
  tags = merge(
        local.common_tags,

        tomap(
          {"Zoo" = "AWS Zoofarm"
	   "Group Name" = "secgroup-${var.myname}-${random_id.server.hex}"
           "RESOURCE" = "security group"
          }
        )
        )

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "terraform_pub_key" {
  key_name   = "TMobile-${random_id.server.hex}"
  public_key = "${file(var.public_key_path)}"
  tags = merge(
        local.common_tags,

        tomap(
          {"Zoo" = "AWS Zoofarm"
          "RESOURCE" = "keypair"
          }
        )
        )
}
