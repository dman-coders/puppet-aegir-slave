# -*- mode: ruby -*-
# vi: set ft=ruby :

require './Vagrantfile.local'
include AWS_vars

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

  # This requires vbox additions to be added, so forget it.
  #config.vm.synced_folder "manifests", "/etc/puppet/manifests"
  #config.vm.synced_folder "modules", "/etc/puppet/modules"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.

  config.vm.provider "virtualbox" do |vb|0
    # Don't boot with headless mode
    # vb.gui = true
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Alternatively, do an AWS provisioning.
  config.vm.provider "aws" do |aws, override|

    # aws.access_key_id     = "SECRET"
    # aws.secret_access_key = "SECRETSECRETSECRET"
    # aws.keypair_name      = "SECRET"

    aws.access_key_id     = $access_key_id
    aws.secret_access_key = $secret_access_key
    aws.keypair_name      = $keypair_name

    # Following instructions at
    # https://help.ubuntu.com/community/EC2StartersGuide
    # From http://cloud-images.ubuntu.com/releases/precise/release/
    # I selected an ebs 64-bit instance of Ubuntu LTS 'Precise' available in ap-southeast-1 (t1-micro)
    # Another recommendation from the Amazon wizard was ubuntu-precise-12.04-amd64-server-20131003 (ami-b84e04ea)
    aws.ami = $ami
    aws.region = $region

    # If I intend to ssh (or sql) in, I need a non-default security group
    # The "default" one 'sg-2e25787c' has no ports open, so I can't even ssh in.
    # This one is mine:
    aws.security_groups           = $security_groups

    override.ssh.username         = $override_ssh_username
    override.ssh.private_key_path = $override_ssh_private_key_path

    config.vm.box                 = "dummy"
    config.vm.box_url             = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  end

  # Puppet versions are out of control. Attempt to use the latest from puppetlabs.
  config.vm.provision :shell, :path => "files/upgrade_puppet.sh"

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
    # puppet.options = "--verbose --debug"
    puppet.options = "--verbose"

  end

end
