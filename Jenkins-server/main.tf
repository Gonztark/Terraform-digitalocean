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

resource "digitalocean_droplet" "jenkins-server" {
  image  = "ubuntu-20-04-x64"
  name   = "jenkins-server"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["fc:88:0d:73:94:04:69:f6:59:79:3d:59:2c:0f:c7:73"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("C:/Users/Eduar/.ssh/id_rsa")
      host        = digitalocean_droplet.jenkins-server.ipv4_address
    }


  provisioner "remote-exec" {
    inline = [
      "set -x",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get -y upgrade",
      "apt-get -y install openjdk-11-jdk",
      "wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
      "sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "apt-get update",
      "apt-get -y install jenkins",
      "systemctl start jenkins"
    ]
  }



}







