# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 6543, host: 6543
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.synced_folder "./encoded", "/home/vagrant/encoded"
  config.vm.synced_folder "./snovault", "/home/vagrant/snovault"
  config.vm.synced_folder "./devservers-encoded", "/home/vagrant/.devservers-encoded"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "8000"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    /home/vagrant/.devservers-encoded/install-devservers.sh
  SHELL
end
