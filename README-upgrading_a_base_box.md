# Bulding a VM from scratch can be slow

The 'precise64' vagrant base box you get as a starter image
by following the instructions is fine, but pretty much always a bit out of date.

Seeing as every puppet script or bootstrap script insist on running
    apt-get upgrade
_all the time_ before even starting, that means that there may be 20 minutes
of thumb-twiddling each rebuild. That makes rapid tear-down futile.

An answer is to

## Update the base box to have the latest versions of all software

If I could, I'd:
* Find and download already-updated versions of the precise64 box
I'm sure they exist, but I can't find instructions.
    vagrant box update --box=hashicorp/precise64 --provider=virtualbox
Seems to not help.
Also, that means huge big file transfers.

So instead, try to:
* Upgrade your local copy of precise64, then re-box it.
This appears possible.
http://www.andrejkoelewijn.com/blog/2012/02/02/updating-a-vagrant-box/

## Replace local precise64 with an upgraded one

So - use VirtualBox (not vagrant) to:
*  File > Import Appliance.
*  Find your vagrant ovf file
  ( ~/.vagrant.d/boxes/precise64/0/virtualbox/box.ovf )
* import that to create a clean VM.
I found that the one I had was named
    box-upgrade_1345488293_1
* start and log in to that machine. (user:pass vagrant:vagrant)
* run

    apt-get update; apt-get dist-upgrade;
    apt-get autoclean; apt-get autoremove;

(I actually did another step to use a LOCAL apt-cache, which saved half an hour here.)
* now repackage that box as a replacement ovf for precise64

    vagrant package --base box-upgrade_1345488293 --output precise64-2014-09.ovf

That takes the temp vm (which was built in "~/VirtualBox VM/box-upgrade_1345488293/"
and creates a new ovf file (in cwd)

    vagrant box add precise64-2014-09 precise64-2014-09.ovf

This *copies* the ovf file into a new cache location ~/.vagrant.d/boxes/
and registers it, automatically adding some meta

        |-- precise64-2014-09
        |   `-- 0
        |       `-- virtualbox
        |           |-- Vagrantfile
        |           |-- box-disk1.vmdk
        |           |-- box.ovf
        |           `-- metadata.json

At this point, I imagine we can rename the old ~/.vagrant.d/boxes/precise64
version and replace it with our new one.

Or, for now, just adapt the Vagrantfile we are testing to use precise64-2014-09
and trust that it's equivalent to
  precise64(with apt-get-updates already run so your startup time is shorter)


### Use a local apt-cache

This is totally optional, and non-portable, *but* you may

* Build a local VM that just has apt-cacher-ng running.
* find its IP, and get other local Virtualvoxes to use it.
* manually, that means:
  # Add a file /etc/apt.conf.d/01proxy that contains only:
  #  Acquire::http::Proxy "http://192.168.56.101:3142";
  Where the IP is the IP of your own apt-cacher,
  and 3142 is the default apt-cache port
* With that in place, the next few apt-get updates for these machines will
be heaps faster.

#### Get puppet to use apt-cache

You can do this inside puppet as well, and that's the most important place
to do it, because bootstrapping a brancd new machine needs to do this
BEFORE all the other puppet scripts start to run and install things.

I use https://github.com/puppetlabs/puppetlabs-apt.git in my puppet modules,
and inside my apt-setup.pp, which is part of my puppet manifests:

    class { 'apt':
      proxy_host           => '192.168.1.103',
      proxy_port           => '3142',
    }

Ideally, I need to put some logic in to check if it's local or remote
before trying to set apt-cache.

