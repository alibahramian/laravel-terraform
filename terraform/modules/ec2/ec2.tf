
terraform {
  required_version = "= 0.11.11"
}

provider "linode" {
  token = "your api"
}

data "linode_region" "main" {
  id = "eu-central"
}

data "linode_instance_type" "default" {
  id = "g6-standard-1"
}

resource "linode_sshkey" "main_key" {
  label   = "public-key"
  ssh_key = "${chomp(file("~/.ssh/id_rsa.pub"))}"
}

resource "linode_instance" "staging-env" {
  label      = "linode113"
  region     = "${data.linode_region.main.id}"
  type       = "${data.linode_instance_type.default.id}"
  private_ip = "false"

  backups_enabled  = "false"
  watchdog_enabled = true

  alerts {
    cpu            = "90"
    io             = "10000"
    network_in     = "10"
    network_out    = "10"
    transfer_quota = "80"
  }

  config {
    label       = "CentOS 7"
    kernel      = "linode-grub2"
    root_device = "/dev/root"

    devices {
      sda = {
        disk_label = "CentOS 7 Disk"
      }

      sdb = {
        disk_label = "1024"
      }
    }
  }

  disk {
    label           = "CentOS 7 Disk"
    size            = "25344"
    image           = "linode/CentOS7"
    authorized_keys = ["${linode_sshkey.main_key.ssh_key}"]
    root_pass       = "Password of the Root User"
  }

  disk {
    label = "1024MB Swap Image"
    size  = "1024"
  }
}
