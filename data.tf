
data "sra_single_vault_ssh_account" "single" {
  name = "ec2-user-short-live-cert"
}

data "sra_jumpoint_list" "filtered" {
  name = "AWS VPC01 Jumpoint" #AWS Windows Customer VPN01
}

data "sra_jump_group_list" "sj" {
  name = "Cloud Infrastructure"  # 
}




 