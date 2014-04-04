# A ground-up build of a puppetized box to run aegir drupal sites.

Built from scratch because all the examples I found had too much stuff that I didn't understand yet.

# Usage

Run

    vagrant up

This will take a while to download the box the first time if you do not
already have it.

run

    vagrant ssh

to connect.

To use another ssh client, the user:pass is vagrant:vagrant

# Diagnostics etc.

To re-apply the full set of puppet scripts, ssh in and:

    sudo puppet apply /vagrant/manifests/site.pp


