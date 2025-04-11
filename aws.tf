provider "aws" {
    region = "us-east-1"
    access_key = "${var.AWS_CLIENT_ID}"
    secret_key = "${var.AWS_CLIENT_SECRET}"
}

provider "sra" {
  host          = "pf922288.beyondtrustcloud.com"
  client_id     = "${var.BT_CLIENT_ID}"
  client_secret = "${var.BT_CLIENT_SECRET}"
}

terraform {
  backend "s3" {
    bucket = "tf-state-info-bt"
    key    = "tf-state/store2"
    region = "us-east-1"
  }
}

resource "aws_instance" "upm-ji" {
  ami                         = lookup(var.AMIS, var.AWS_REGION)
  instance_type               = "t2.micro"
  count                       = var.instance_count
  subnet_id                   = "subnet-030778edf8810e0d4"
  vpc_security_group_ids      = ["sg-0e18482d4d2c58b51"]
  associate_public_ip_address = "false"
  key_name                    = "AWS_SE_GREEN"
  tags = {
    Name = "${var.ec2-name}${count.index}"
  }
  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }
    user_data = base64encode(join("", [
    "#! /bin/bash\n",

    "set -euo pipefail\n",
    "set -x\n",

    "TARGET_USER=\"${lookup(var.aws_users, var.username)}\"\n",
    "HOME=/home/$TARGET_USER\n",
    
    # Add PRA Cert Auth to EC2 User
    "echo \"${data.sra_single_vault_ssh_account.single.account.public_key}\" > $HOME/.ssh/authorized_keys\n",
    
    # Configure EC2 user for vault CA certificate authentication
    "echo \"${data.sra_single_vault_ssh_account.single.account.public_key}\" > $HOME/.ssh/authorized_keys\n",
    "chown ec2-user:ec2-user $HOME/.ssh/authorized_keys\n",

    # Add PSRUN2 to users dir
    "curl -o $HOME/psrun2 https://therepo.blob.core.windows.net/repo/init/pws/psrun2\n",
    "chown ec2-user:ec2-user $HOME/psrun2\n",
    "chmod +x $HOME/psrun2\n",

    # Insatll EPM-L
    "EPMLC_Token=\"${var.EPMLC-Join}\"\n",
    "cd /tmp\n",
    "sudo dnf install -y libxcrypt-compat\n",
    "sudo curl -sfLo epml-client.x86_64.rpm https://therepo.blob.core.windows.net/repo/init/epmlc/oasis-epml-client.x86_64.rpm\n",
    "rpm -i /tmp/epml-client.x86_64.rpm\n",
    "/usr/sbin/pbactivate -t $EPMLC_Token\n",
    
    # Install ADB & Join to Entra ID
    "TENANTID=\"${var.adb.TENANTID}\"\n",
    "APPID=\"${var.adb.APPID}\"\n",
    "APPSEC=\"${var.adb.APPSEC}\"\n",
    "ADBLIC=\"${var.adb.ADBLIC}\"\n",
    "sudo curl -o /etc/yum.repos.d/adbridge.repo https://repo.pbis.beyondtrust.com/yum/pbise.repo\n",
    "sudo yum -y install pbis-enterprise\n",
    "sleep 5\n",
    "sudo echo $APPSEC >./joinsec\n",
    "sudo /opt/pbis/bin/tenantjoin-cli join --tenant-id $TENANTID --app-id $APPID  --app-secret-file ./joinsec\n",
    "sudo /opt/pbis/bin/setkey-cli --key Y5P4Y-PN3HX-MQW7W-GEWEK-OADMHQ\n",
    "sudo rm ./joinsec\n"
    

  ]))
}