resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = var.ami_id
  }

  byte_length = 8
}

data "aws_ami" "jumpserver" {
  most_recent = true
  tags = merge(
        local.common_tags,

        tomap(
          {"Zoo" = "AWS Zoofarm"
          "RESOURCE" = "amazon linux2 server"
          }
        )
        )
  filter {
    name   = "name"
    values = ["*Craig's Jumpserver Devserver*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["315238358115"] # Craig's AMI of Adrians Deployer

}

resource "aws_instance" "jumpserver" {
  tags = merge(
        local.common_tags,

        tomap(
          {"Zoo" = "AWS Zoofarm"
	   "Name" = "${var.myname}-${random_id.server.hex}-${count.index + 1}"
           "RESOURCE" = "jumpserver AMI"
          }
        )
        )
  ami                         = data.aws_ami.jumpserver.id
  availability_zone           = var.AWS_AZ
  instance_type               = var.INSTANCE_TYPE
  key_name                    = aws_key_pair.terraform_pub_key.key_name
  vpc_security_group_ids      = [aws_security_group.allowall.id]
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  #user_data                   = file("usertools.sh")
  count                       = var.instance_count
  # root disk
  root_block_device {
    volume_size           = "50"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = false
  }
  # data disk
  #ebs_block_device {
  #  device_name           = "/dev/xvda"
  #  volume_size           = "50"
  #  volume_type           = "gp2"
  #  encrypted             = true
  #  delete_on_termination = false
  #}
}

  #user_data_base64 = "${data.template_file.uservars.rendered}"

#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt update",
#      "sudo apt-get -y install python",
#      "sudo apt-get -y install software-properties-common",
#      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
#      "sudo apt-get -y install ansible",
#      "cd ansible; ansible-playbook -vvv -c local -i \"localhost,\" armor.yml",
#      "sudo apt-get install curl unzip",
#      "sudo apt-get jq"
#    ]

#    connection {
#      host        = self.public_ip
#      type        = "ssh"
#      user        = var.ssh_user
#      private_key = file(var.private_key_path)
#    }
  #}
  #Don't comment out this next line.
#}
#resource "local_file" "rendered_userdata" {
#  content = data.template_cloudinit_config.master.rendered
#  filename = "rendered_userdata.txt"
#  
#}