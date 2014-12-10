# A ground-up build of a puppetized box to run aegir drupal sites.

Built from scratch because all the examples I found had too much stuff that I didn't understand yet.

# Usage

Run

    vagrant up

This will take a while to download the box the first time if you do not
already have it.

## AWS and DigitalOcean

    vagrant up --provider=aws

or

    vagrant up --provider=digitalocean

can also work, though you need to first set up your authentication keys.
See README-AWS-

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

