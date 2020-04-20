# -*- mode: ruby -*-
# vi: set ft=ruby :

# # Import shared configuration
# require 'yaml'
#
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "debian/buster64"

  # Do not auto update guest utilities (installation fails on first boot)
  config.vbguest.auto_update = false

  # Map host SSH into the guest
  # config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa' ]
  # config.ssh.forward_agent = true

  # Workaround to prevent missing linux headers making new installs fail.
  # Put into Vagrantfile directly under your `config.vm.box` definition
  # https://github.com/dotless-de/vagrant-vbguest/issues/351#issuecomment-594656511
  # class WorkaroundVbguest < VagrantVbguest::Installers::Linux
  #   def install(opts=nil, &block)
  #         # Configure apt proxy if it is available
  #         config_yml = YAML.load(File.read("config.yml"))
  #         if config_yml.has_key? 'apt_proxy'
  #
  #           apt_proxy = config_yml["apt_proxy"]
  #
  #           puts 'Adding apt proxy information: ' + apt_proxy
  #
  #           communicate.sudo("echo 'Acquire::http::Proxy \"" + apt_proxy + "\";' > /etc/apt/apt.conf", (opts || {}).merge(:error_check => false), &block)
  #
  #         end
  #
  #         puts 'Ensuring we\'ve upgraded...'
  #
  #         communicate.sudo('apt-get -y --force-yes update', (opts || {}).merge(:error_check => false), &block)
  #
  #         communicate.sudo('export DEBIAN_FRONTEND=noninteractive; apt-get -y --force-yes dist-upgrade', (opts || {}).merge(:error_check => false), &block)
  #
  #         communicate.sudo('shutdown -r now', (opts || {}).merge(:error_check => false), &block)
  #
  #         puts 'Ensuring we\'ve got the correct build environment for vbguest...'
  #
  #         communicate.sudo('apt-get -y --force-yes install -y build-essential linux-headers-amd64 linux-image-amd64', (opts || {}).merge(:error_check => false), &block)
  #
  #         puts 'Continuing with vbguest installation...'
  #
  #       super
  #         puts 'Performing vbguest post-installation steps...'
  #           communicate.sudo('usermod -a -G vboxsf vagrant', (opts || {}).merge(:error_check => false), &block)
  #   end
  #
  #   def reboot_after_install?(opts=nil, &block)
  #     true
  #   end
  #
  # end
  #
  # config.vbguest.installer = WorkaroundVbguest

  # Configure whether to set up a build environment or a generic raspbian
  # container.
  if ENV['START'] == 'generic'

    generic = true

  else

    generic = false

  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  if generic == true

    config.vm.network "forwarded_port", guest: 2022, host: 2022, host_ip: "127.0.0.1"

  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # if generic == true
  #
  #   config.vm.synced_folder "~/.ssh", "/host_ssh_keys", mount_options: ["ro"]
  #
  # end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.become = true
    ansible.playbook = "vagrant-upgrade-playbook.yml"
  end

  config.vm.provision :reload

  if generic == true

    config.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.become = true
      ansible.playbook = "generic-rpi-container-playbook.yml"
    end

  else

    config.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.become = true
      ansible.playbook = "sensor-pod-build-playbook.yml"
    end

  end
end
