# A ground-up build of a puppetized box to run aegir drupal sites.

Built from scratch because all the examples I found had too much stuff that I didn't understand yet.

# Usage

Run

    vagrant up

This will take a while to download the box the first time if you do not
already have it.

## ssh

run

    vagrant ssh

to connect.

To use another ssh client, the user:pass is vagrant:vagrant
and more info about connecting (port 2222 and IP) may be seen by running

     vagrant ssh-config

## Website

The website it sets up is accessible via port forwarding, so may be found at

http://localhost:8080

# Diagnostics etc.

The puppet client should already be on the system.

It installs local things at /etc/puppet.

To re-apply the full set of puppet scripts, ssh in and:

    sudo puppet apply /vagrant/manifests/site.pp


More docs that took ages to unpack. To add a module directly on the guest:
( probably should not do this, but when testing, this is the command )

    puppet module --modulepath /vagrant/modules install puppetlabs-stdlib


# Intallation dependencies

Using the puppetlabs Apache module requires
'puppetlabs/stdlib'
'puppetlabs/concat'


