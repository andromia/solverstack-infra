# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANT_BOX = "bento/ubuntu-20.04"
ALLOCATED_MEMORY = "512"

Vagrant.configure(2) do |config|
  
    config.vm.provider "virtualbox" do |vb|
      vb.memory = ALLOCATED_MEMORY
    end
  
    config.vm.box = VAGRANT_BOX
    
    # Install Docker
    config.vm.provision :docker
  
    # Install Docker Compose
    # First, install required plugin https://github.com/leighmcculloch/vagrant-docker-compose:
    # vagrant plugin install vagrant-docker-compose
    config.vm.provision :docker_compose

    config.vm.network :forwarded_port, guest: 80, host: 80
    config.vm.network :forwarded_port, guest: 8080, host: 8080
    config.vm.network :forwarded_port, guest: 8081, host: 8081
  
    config.ssh.forward_agent = true
  
    # TODO: resolve -> Warning: Permanently added 'github.com,140.82.113.3' (RSA) to the list of known hosts.
    # config.vm.provision "shell", inline: <<-SHELL

    # SHELL

    end