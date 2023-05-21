Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.synced_folder ".", "/vagrant/home/Pomegranate-suite", type: "virtualbox"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provider :virtualbox do |v|
    v.gui = true
    v.memory = 4096
    v.cpus = 2
  end
  config.vm.provision :shell, inline: "sudo apt update -y"
  config.vm.provision :shell, inline: "sudo apt upgrade -y"
  config.vm.provision :shell, inline: "sudo apt install -y --no-install-recommends ubuntu-desktop"
  config.vm.provision :shell, inline: "sudo apt install -y --no-install-recommends virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11"
  config.vm.provision :shell, inline: "sudo usermod -a -G sudo vagrant"
  config.vm.provision :shell, inline: "sudo shutdown -r now"
  config.vm.provision :shell, path: "bootstrap.sh"

end

