# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load local settings - these may contain personalized settings such
# as server keys.
#
# A sample Vagrantfile.local.dist.rb lists the expected settings.
#
if File.exist?('./Vagrantfile.local.rb')
 require './Vagrantfile.local'
 puts "Loaded local API keys and settings"
 include AWS_vars
 include DIGITALOCEAN_vars
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  # The location of this one will be autodetected, served from a vagrant repo
  # and can be updated automatically.
  # config.vm.box = "hashicorp/precise64"

  # Different setups for different providers

  # VirtualBox local
  # ================
  config.vm.provider "virtualbox" do |vb|0
    # Where to get this from is autodetected from vagrant repos.
    config.vm.box = "hashicorp/precise64"
    # Don't boot with headless mode
    # vb.gui = true
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]

    # Set the apt-cacher. This is a per-environment setting.
    # not part of the box rules really.
    config.vm.provision :shell, :inline => "echo 'Acquire::http::Proxy \"http://192.168.56.101:3142\";' >  /etc/apt/apt.conf.d/proxy "

  end

  # Alternatively, do provisioning on
  #
  # Amazon Web Services EC2
  # =======================
  config.vm.provider "aws" do |aws, override|
    # the variable named 'aws' represents the aws specific params,
    # the variable named override represents broader params.

    # @see Vagrantfile.local.dist.rb for settings examples exist.
    # This example requires you to have the vagrant-aws plugin.
    # https://github.com/mitchellh/vagrant-aws
    # Developed using version 0.4.1

    # aws.access_key_id     = "SECRET"
    # aws.secret_access_key = "SECRETSECRETSECRET"
    # aws.keypair_name      = "SECRET"

    aws.access_key_id     = $aws_access_key_id
    aws.secret_access_key = $aws_secret_access_key
    aws.keypair_name      = $aws_keypair_name

    # Following instructions at
    # https://help.ubuntu.com/community/EC2StartersGuide
    # From http://cloud-images.ubuntu.com/releases/precise/release/
    # I selected an ebs 64-bit instance of Ubuntu LTS 'Precise' available in ap-southeast-1 (t1-micro)
    # Another recommendation from the Amazon wizard was ubuntu-precise-12.04-amd64-server-20131003 (ami-b84e04ea)

    # aws.ami = "ami-d44e1f86"
    # aws.region = "ap-southeast-1"

    aws.ami = $aws_ami
    aws.region = $aws_region

    # This one is mine. *you have the set this up yourself through aws*.
    # aws.security_groups           = ["basic ports open"]

    aws.security_groups           = $aws_security_groups

    aws.instance_type = "m1.small"
    aws.tags = {"Provisioner" => "Vagrant built"}
    # How to set a label?


    # AWS needed to use private_key_path
    # because it expects a .pem, not a .id_rsa
    override.ssh.username         = $override_ssh_username
    override.ssh.private_key_path = $override_ssh_private_key_path

    # This defines the stub box definition.
    override.vm.box                 = "aws_dummy"
    override.vm.box_url             = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"


  end

  # Alternatively, do provisioning on
  #
  # DigitalOcean
  # =======================
  config.vm.provider "digital_ocean" do |provider, override|
    # the variable named 'provider' represents the digitalocean specific params

    # Following instructions from https://www.digitalocean.com/community/tutorials/how-to-use-digitalocean-as-your-provider-in-vagrant-on-an-ubuntu-12-10-vps
    # and https://github.com/smdahlen/vagrant-digitalocean#install (more up to date)

    # The $digitalocean_ parameters are kept out of source control
    # and should be included by providing your own Vagrantfile.local.rb
    # @see Vagrantfile.local.dist.rb

    provider.client_id = $digitalocean_client_id
    ## provider.api_key = $digitalocean_api_key
    ## note, 'api_key' is old syntax,
    provider.token = $digitalocean_token
    provider.image = "LAMP on Ubuntu 14.04"
    provider.region = "sfo1"

    # Optional
    provider.size = "512mb"
    provider.ssh_key_name = "vagrant"

    # This defines the stub box definition.
    override.vm.box                 = "digitalocean_dummy"
    override.vm.box_url             = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    # It appears this is required. Dunno why it did not just default.
    override.ssh.private_key_path = "~/.ssh/id_rsa"
  end


  # Provision with
  #
  # Puppet
  # =======================
  # Puppet versions are out of control and impossible to follow.
  # Attempt to use the latest from puppetlabs.
  config.vm.provision :shell, :path => "files/upgrade_puppet.sh"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  config.vm.provision "puppet" do |puppet|

    # puppet.manifests_path = "manifests"
    # puppet.manifest_file  = "default.pp"
    # When designing for puppetmaster, the base manifest may be site.pp
    # and many docs refer to that instead of 'default.

    # Setting the manifest_file to a dir means load all pp in that dir
    # That's apparently recommended over 'import' now.
    puppet.manifests_path = "manifests"

    puppet.module_path = "modules"

    # The docs at http://friendsofvagrant.github.io/v1/docs/provisioners/puppet.html
    # were unclear to a ruby-noob, but this is how to pass additional options.
    puppet.options = "--verbose"

  end

end
