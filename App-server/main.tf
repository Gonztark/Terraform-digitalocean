terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {
  default = ""
}

provider "digitalocean" {
  token = var.do_token != "" ? var.do_token : getenv("DO_API_TOKEN")
}


resource "digitalocean_droplet" "app" {
  image  = "ubuntu-20-04-x64"
  name   = "app"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["46:0d:6d:ed:f4:21:6e:60:20:a3:a5:be:5b:12:e1:c6"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("/root/.ssh/id_rsa")
      host        = digitalocean_droplet.app.ipv4_address
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install docker.io -y",
      "sudo apt install docker-compose -y",
      "sudo apt install git -y",
    ]

    
  }
}






