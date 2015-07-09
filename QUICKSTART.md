# Trialling the proof-of-concept

On a very clean machine

* Install vagrant https://www.vagrantup.com/downloads.html

* Checkout the puppet-aegir-slave

https://github.com/dman-coders/puppet-aegir-slave

    cd ~/vagrant/projects
    git clone git@github.com:dman-coders/puppet-aegir-slave.git
    cd puppet-aegir-slave/
    git submodule update --init

* Run a local Vagrant+VirtualBox

    vagrant up # (20 minutes +)

( Can also switch to AWS or DigitalOcean, see the README-AWS-EC2.txt )

MANUAL STEP

Whilst still in development mode,
the puppet provisioning may not kick off automatically.
(I'm still trying to figure out the correct paths and puppetmaster)
A couple of manual steps are used instead.

Log in:

    vagrant ssh
     
### Now can run Puppet on its own
    
    cd /vagrant
    sudo puppet apply --modulepath=/vagrant/modules /vagrant/manifests
    # Should pull in the rest of the needful things.
   
    
To see if it worked, should successfully run:

    sudo su aegir
    drush status
    

## Notes

This successfully gets the pop-up server to the state where it is a headless web slave.
* It does not have any working Drupal site on it *
It's a vessel that I can now point an aegir hostmaster at to use as a hosting engine.
  http://www.aegirproject.org/
Because from here the automation of site builds, releases, db provisioning can
  be managed using these tools.

### About the contents of the repo

https://github.com/dman-coders/puppet-aegir-slave

  The pain is documented in NOTES.md. Ignore that.
  The contents of /modules/ are stable third party libs. Assume they are OK.
  The local interesting bits are in /manifests/ and /files/ .
  My local /manifests/ are 50% notes-to-self and gotchas.
  The aegir-slave-setup.pp is the only unique Drupal-dev part.
    The rest is just 'Make a LAMP'.
  The Vagrantfile is a lot of make-it-up-as-i-go based on various
    half-examples I found.
  Expectations and requirements have changed since this was built.
    Importantly, the way drush installs itself has switched from apt to composer.
  
### This build is incomplete!

  The wish-list of the ACTUAL desired base box includes:
  
  * Backup scheme on and enabled.
  * DNS registration from below.
  * Munin or Nagios auto-registration.
  * Individual Developer user account setups.
  * Ruby/SASS/Compass/Bundler installs for developers.
  * Additional phone-home self-registration to our central list of sites (currently a list of small config files in a shared git repo).
  
  These things all seem like there should be solved solutions for them out there, but the
  tutorials I found all seemed hacky.
  Which is where I stopped.
  
  