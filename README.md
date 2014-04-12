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

.. fails in 2.7.11



# Intallation dependencies

Using the puppetlabs Apache module requires
'puppetlabs/stdlib'
'puppetlabs/concat'


# More

This was pulled together by referring to multiple sources.
I still can't figure out why every example seems to create its own full
libraries of Puppet class files and manifests - isn't the point to re-use
the common setup requirements and make them overridable as needed
- not to rewrite them every time?

https://puphpet.com/
Gave me some hints, but the auto-generated code was so riddled with
OS-related if-thens that it was hard to read.

https://github.com/mikkeschiren/vagrant-example
Looks clearer, but despite seeming simple on the top where it just listed the
included modules by name, it also distributes the full source code of those
handmade modules. Where is the re-use?

Variations of aegir-up kept their code in funny places

# Things I did not know

## Order of operations

Puppet does not run your actions in order as specified in your .pp file.
That's madenning until you end up listing all the dependency orders/

## Language:

  class util-setup {

and

  class { 'util-setup':

Are *totally* different parts of the language.
The first begins a class declaration that we out code actions into.
The second re-uses an existing class found in /modules, referred to by name
 and optionally sets some parameters to use when wh call it.

The first one does NOT instantiate the class, and requires you to
  include "util-setup"

The second one DOES instantiate it immediately!
http://garylarizza.com/blog/2011/03/11/using-run-stages-with-puppet/
