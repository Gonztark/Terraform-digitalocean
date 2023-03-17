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
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "app" {
  image  = "ubuntu-20-04-x64"
  name   = "app"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["fc:88:0d:73:94:04:69:f6:59:79:3d:59:2c:0f:c7:73"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("C:/Users/Eduar/.ssh/id_rsa")
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






