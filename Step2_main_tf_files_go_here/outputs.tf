output "jumpserverMETA" {
    value = aws_instance.jumpserver
}

output "jumpserverUSER" {
    value = var.ssh_user
}

output "jumpserverKEY" {
    value = var.private_key_path
}

output "jumpserverIP" {
    value = aws_instance.jumpserver[*].public_dns
}

output "jumpserverEIP" {
    value = aws_eip.jumpserver[*].public_dns
}

#output "rendered" {
#    value = data.template_cloudinit_config.master.rendered
#}