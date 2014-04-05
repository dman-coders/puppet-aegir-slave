# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  # The location of this one will be autodetected, served from a vagrant repo
  # and can be updated automatically.
  config.vm.box = "hashicorp/precise64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.

  config.vm.provider "virtualbox" do |vb|0
    # Don't boot with headless mode
    # vb.gui = true
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  config.vm.provision "puppet" do |puppet|

    # puppet.manifests_path = "manifests"
    # puppet.manifest_file  = "default.pp"
    # When designing for puppetmaster, the base manifest may be site.pp
    # and many docs refer to that instead of 'default.

    puppet.module_path = "modules"

    # The docs at http://friendsofvagrant.github.io/v1/docs/provisioners/puppet.html
    # were unclear to a ruby-noob, but this is how to pass additional options.
    puppet.options = "--verbose --debug"

  end

end
