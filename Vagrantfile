# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "oraclelinux/9-btrfs"
  config.vm.box_url = "https://oracle.github.io/vagrant-projects/boxes/oraclelinux/9-btrfs.json"
  config.vm.hostname = "WebFE-OEL9"

  # config.vagrant.plugins = ["vagrant-vbguest","vagrant-persistent-storage"]
  # config.vbguest.auto_update = true
  config.ssh.key_type = :ecdsa521 # Requires Vagrant 2.4.1

  ############################################################################
  # Provider-specific configuration                                          #
  ############################################################################
  config.vm.provider "virtualbox" do |vb|
    # Set Name
    vb.name = "Web Frontend Collector - OEL9 Base"

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    
    # Customize CPU & Memory
    vb.cpus = 6
    vb.memory = 8192
    
    # Set up VM options
    vb.customize ["modifyvm", :id, "--vm-process-priority", "normal"]
    vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]
    vb.customize ["modifyvm", :id, "--audioin", "on"]
    vb.customize ["modifyvm", :id, "--audiocontroller", "hda"]
    vb.customize ["modifyvm", :id, "--vrde", "off"]
  end

  ############################################################################
  # File copy provisioners                                                   #
  ############################################################################
  config.vm.provision "file", source: "~/.ssh", destination: ".ssh"
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"

  ############################################################################
  # Shell script provisioner                                                 #
  ############################################################################
  config.vm.provision "shell", inline: <<-'SHELL'
    # Disable gnome-initial-setup for new users
    mkdir -p /etc/skel/.config/
    touch /etc/skel/.config/gnome-initial-setup-done
    mkdir /home/vagrant/.config
    touch /home/vagrant/.config/gnome-initial-setup-done

    # Import .ssh to vagrant user
    chown -R vagrant:vagrant /home/vagrant
    chmod -R 600 /home/vagrant/.ssh
    chmod 700 /home/vagrant/.ssh

    # Setup Rootless Podman
    sysctl user.max_user_namespaces=15000
    sed -i 's/user.max_user_namespaces=0/user.max_user_namespaces=15000/i' /etc/sysctl.conf
    usermod --add-subuids 200000-201000 --add-subgids 200000-201000 vagrant
    groupadd -r docker
    usermod -aG docker vagrant
    mkdir /etc/containers
    touch /etc/containers/nodocker

    ############################################################################
    # Add Software                                                             #
    ############################################################################
    # Add EPEL
    echo -e "\nInstalling additional repos\n"
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    curl -fsSL https://cli.github.com/packages/rpm/gh-cli.repo >\
      "/etc/yum.repos.d/github-cli.repo"
    echo
    /usr/bin/crb enable

    # Install Dev Software
    dnf module -y reset nodejs
    dnf module -y enable nodejs:20
    dnf distro-sync -y

    # Install Container/Additional Software
    dnf install -y podman skopeo podman-docker podman-compose tmux tree \
      git git-lfs rsync gh nodejs yarnpkg mkisofs isomd5sum

    # Final Software Update 
    dnf update -y
  SHELL

  # # Reboot to prepare to enable FIPS
  # config.vm.provision 'shell', reboot: true

  # Enable Fips
  config.vm.provision "shell", inline: <<-'SHELL'
    Enable FIPS
    fips-mode-setup --enable
  SHELL

  # Reboot to enable FIPS
  config.vm.provision 'shell', reboot: true
end
