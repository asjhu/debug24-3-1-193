resource "sra_shell_jump" "ji-ssh" {
  count         = var.instance_count
  name          = "${var.ec2-name}${count.index}"
  hostname      = aws_instance.upm-ji[count.index].private_ip
  jumpoint_id   = data.sra_jumpoint_list.filtered.items[0].id
  jump_group_id = data.sra_jump_group_list.sj.items[0].id
  tag           = "IaC AWS" # Vault account group tag ec2-user
  username      = "ec2-user-jit"
}