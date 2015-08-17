
Vagrant.configure(2) do |config|

  # Specify the base box
  config.vm.box = "ubuntu/trusty64"

  # Setup port forwarding
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

  # Setup network
  config.vm.network "private_network", ip: "192.168.33.10"

  # Setup synced folder
    config.vm.synced_folder "www/", "/var/www/html", group: "www-data", owner: "vagrant", :mount_options => ['dmode=775', 'fmode=775']

  # CUSTOMIZATION
   config.vm.provider "virtualbox" do |vb|

    vb.name = "devspace"
  
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.cpus = 1
   end


  # PROVISION
  config.vm.provision "shell", inline: <<-SHELL
    echo "Provisioning virtual machine..."
    echo "=========================================="
  SHELL

  config.vm.provision "shell", path: "vagrant/bootstrap.sh"

  config.vm.provision "shell", path: "vagrant/lamp.sh"

  config.vm.provision "shell", path: "vagrant/extra.sh"

  config.vm.provision "shell", inline: <<-SHELL
    echo "=========================================="
    echo "Finished provisioning."
  SHELL

  #SSH
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
