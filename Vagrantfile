# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.hostname = "phalcon"

  config.vm.network :forwarded_port, guest: 3306, host: 3306, auto_correct: true
  config.vm.network :forwarded_port, guest: 80,   host: 8080, auto_correct: true
  
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
 	  vb.memory = 2040
 	  vb.cpus = 2
    
    vb.customize [
      "modifyvm", :id,
      "--ioapic", "on",
      "--natdnsproxy1", "on",
      "--natdnshostresolver1", "on",
      "--ostype", "debian_64"
    ]
  end  

  config.vm.provision :shell, path: "php7_repo.sh"
  config.vm.provision :shell, path: "phalcon_repo.sh"
  config.vm.provision :shell, path: "install_packages.sh"

  config.vm.provision :file,  source: "composer-setup.php", destination: "composer-setup.php"
  config.vm.provision :shell, inline: "php composer-setup.php --install-dir /usr/local/bin --filename composer"
  config.vm.provision :shell, path: "composer_packages.sh"
 
  config.vm.provision :shell, path: "default_nginx.sh"
 
  config.vm.synced_folder ".", "/vagrant", disabled: true 
 
  config.vm.synced_folder "code", "/home/vagrant/code", 
    type: "rsync",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775, fmode=664"]   
end
