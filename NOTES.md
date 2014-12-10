## Warning

This probably won't work for anyone but me - it was built on a local Virtualbox
and it's hard-coded to use a local apt-cacher I keep on another VM.
Because it takes 40 minutes to provision from scratch each time if I try to do
a dist-upgrade at home otherwise.

I found that almost no online help docs worked, as the versions of Puppet have
changed so much in the last 2 years it's impossible to find what best-practice,
or even 'supported' methodology is.

Seriously, do not expect this to work or to learn anything off it. It's only
in git so I can experiment with puppetmaster provisioning etc.

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

Seeing as I thought the entire purpose of using puppet was *not* to re-invent
the wheel and just be able to say "I need Apache and PHP with mem_limit of 256"
I'm trying REALLY hard to re-use and import existing module manifests.
But most of the ones I find are horrible.
All the interesting tutorials teach us to go ahead and make our own thing,
and are full of individual file edits and shell calls,
or have exploded into dozens of enterprise-level dependency-hells.
What am I to do?

So I'm using git submodules to pull in a small handfull of what look like sane
lliraries from puppetlabs.
I get puppet modules for apt, apache and mysql from there.
Could not find one for PHP

Using the puppetlabs modules also requires
'puppetlabs/stdlib'
'puppetlabs/concat'

I'm still having trouble with the execution order for apt.

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

## apt versions

If we use only the Ubuntu stable repositories, we have very little choice as
to the available versions.
On 'precise', PHP is locked to "5.3.10-1ubuntu3.11".
Note that the full string is required as the version. Though "5.3.10-1ubuntu3"
also works.

We can tell the package manager to

    package { "php5":
      ensure => "5.3.10-1ubuntu3.11",
    }

And that will work, but no other number will.
For other versions, we will need to add a different repo.

Adding a private repo where newer versions of PHP can be got is helpful.
http://www.jeffmould.com/2013/10/06/upgrading-from-php-5-3-to-5-x-on-ubuntu-12-04/
Though that requres you to know the obscure version number also :
"5.5.11-2+deb.sury.org~precise+2"

### Specific versions

But what about older versions?

And what about downgrading (and holding/pinning)?

The terminology is now 'hold'. 'Pin' is mutable and only hints at the version
we want but _does not enforce it_ if some other thing wants to pull the old
version up..


If I try to use this months new Ubuntu LTS ('trusty')
and used "ensure present"
I would get given  *5.5.9+dfsg-1ubuntu4*

Listing the available versions does not show me any other choices:

    apt-cache madison php5

... Not unless additional repos are added.

By adding

    deb http://bg.archive.ubuntu.com/ubuntu/ precise main restricted

We get access to *5.3.10-1ubuntu3*
Then we need to specify the version and also 'hold' the version
for *all* php-related mods.


### Clean-slate to begin

If they have already been installed :

Find them all
    dpkg --get-selections | grep php
    dpkg -l | grep php
kill them all
    apt-get purge php5 php5-common php5-gd php5-mysql php5-cgi php5-cli php-pear php5-curl php5-json php5-readline libapache2-mod-php5


But on a new box, that's no big deal.
Instead, use the puppetlabs-apt tool and 'hold' them.
https://github.com/puppetlabs/puppetlabs-apt

It turns out that puppetlabs 'hold' is really only a 'pin' :-(
This works by giving a higher priority to the older archive version when
installing it specifically, though it does not prevent accidental upgrades.

### Madness with circular loops

It turns out that specifying a perferred version for one part of php, but not
for others (like php5-gd) craps out, OR forcibly upgrades the thing you were
trying to keep back OR produces some combination of the two.
We need to hold them all at the same time. And this is possible by putting all
versions and numbers on the same line using apt-get, but NOT when using puppet
as it installs each package one by one, in no special order.
(Seriously, it's like it randomizes my lists each run)

To get this all installed at all, we need to 'pin' and define our preferred
install versions, so that when dependencies are auto-installed, they are the
*right versions*.

### Diagnostics

To find what version is installed,

    dpkg -l | grep php

To add pins, use the puppet-apt utility apt::hold in the manifest

    apt::hold { $packages:
      # Here it requires the partial version number.
      version => '5.7.10*',
    }

Which produces configs ('pins') in /etc/apt/preferences.d like so:

    Explanation: apt: hold php5 at 5.7.10*
    Package: php5
    Pin: version 5.7.10*
    Pin-Priority: 1001

To find what _priorities_ the competing versions have

    apt-cache policy php5-cgi

However the output from that is deceptive. Explained a little better here.
http://carlo17.home.xs4all.nl/howto/debian.html#errata

    php5-cgi:
      Installed: (none)
      Candidate: 5.3.10-1ubuntu3
      Package pin: 5.3.10-1ubuntu3
      Version table:
         5.5.9+dfsg-1ubuntu4 1000
            500 http://mirrors.digitalocean.com/ubuntu/ trusty/main amd64 Packages
         5.3.10-1ubuntu3 1000
            500 http://bg.archive.ubuntu.com/ubuntu/ precise/main amd64 Packages

The 1000 there is only a value to match against, not the value found.

We specified that
"A version 5.3.10 is worth 1000 points, now search for anything that meets or beats that value"
And that has been correctly identified as the "candidate",
no matter what the weightings on the repository lists are
(500 and 500 respectively, as both candidates are from stable milestone repos).

### Gotchas

* The gotcha that killed me was that the 'version' in a 'pin'
  is not the full version string we use elsewhere, like in apt-get.
  NOT:     5.3.10-1ubuntu3
  INSTEAD: 5.3.10*
  This lost me the whole day.

* Actually, what lost me the rest of the day was that apt::hold creates
  conf files with spaces in, and SPACES DO NOT WORK.
  This seems to be an accidental bug.
  https://tickets.puppetlabs.com/browse/MODULES-727

* If you specify a version that is not available from the current repos,
  it ignores you and takes a guess as if you said nothing.
  Gee thanks.

* If you then install something that is not pinned, and the latest version of
  that expects the latest version of the somnething that *is* pinned,
  the pinned thing will be instantly upgraded to meet the newbies expectations!
  Instant death, why did we bother.
  Need to also 'hold' it to prevent this from happening.


### Really 'holding' a version

Doing something innocuous manually now, like

    apt-get install php5-ldap

Can destroy all our fun. It will pull everything we intended to hold back
along to the latest release.

Puppetlabs apt::hold (right now) does NOT actually 'hold' (and lock) it,
despite its name.
Some excuses for this are in the docs, but the promised solution does not deliver.
https://github.com/puppetlabs/puppetlabs-apt
The concept it refers to as
"causes a version to be installed even if this constitutes a downgrade of the package"
http://www.howtoforge.com/a-short-introduction-to-apt-pinning
does NOT prevent later dependencies from upgrading the parent.

To really do that,

    apt-mark hold php5-common

So now, an inadvertant and presumed safe action like:

    apt-get install php5-ldap

Will NOT kill everything, it will just make you figure out that life is terrible
and you need to go:

    apt-get install php5-ldap=5.3.10-1ubuntu3

Note that AFTER locking a package, apt-get will complain and die if you try a
simple update that would break the lock.
It doesn't even tell you where the lock is!
But if you use aptitude, it will problem-solve for you:

    $ aptitude install php5-xsl
    The following NEW packages will be installed:
      libxslt1.1{a} php5-xsl{b}
    0 packages upgraded, 2 newly installed, 0 to remove and 7 not upgraded.
    Need to get 159 kB of archives. After unpacking 587 kB will be used.
    The following packages have unmet dependencies:
     php5-xsl : Depends: phpapi-20121212 which is a virtual package.
                Depends: php5-common (= 5.5.9+dfsg-1ubuntu4) but 5.3.10-1ubuntu3 is installed and it is kept back.
    The following actions will resolve these dependencies:

         Keep the following packages at their current version:
    1)     php5-xsl [Not Installed]

    Accept this solution? [Y/n/q/?] n


    The following actions will resolve these dependencies:

         Install the following packages:
    1)     php5-xsl [5.3.10-1ubuntu3 (precise)]


    Accept this solution? [Y/n/q/?]

Yep, that is the solution.

### Alternate approaches

The above mess-around gets PHP 5.3 onto a newer system ... but not yet working
under Apache. To plug in and actually work on a webserver, we would enable
mod_php, (libapache2-mod-php5).
HOWEVER, it turns out that that bridge module only exists in binaries that
bid together similar versions of releases. In short, you can't use
an old libapache2-mod-php5 with new Apache, and you can't use a new
libapache2-mod-php5 with old PHP. Not without rebuilding from source.

#### Downgrade Apache to the old matching mod-php version

The most straightforward way here is to give up and downgrade Apache also!
This is in manifests/amp-precise.pp

#### Decouple Apache and use php-cgi

Though no longer popular, the solution may be to run php stand-alone.

    apt-get install -t precise php5-cgi
    a2enmod actions
    sudo a2dismod php5

then create a file

    # /etc/apache2/conf.d/php5-cgi.conf (precise)
    # /etc/apache2/conf-enabled/php5-cgi.conf (trusty)
    # CUSTOM: Add PHP 5 parsing (via CGI) handler and action
    ScriptAlias /bin /usr/bin
    AddHandler application/x-httpd-php5 php
    Action application/x-httpd-php5 /bin/php-cgi
    <Directory "/usr/bin">
        Order allow,deny
        Allow from all
    </Directory>

Restarting apache and visiting a phpinfo page should now NOT show the
apache2handler chunk, and instead list *Server API : CGI/FastCGI*
Hopefully the rest runs as expected.

.. but yeah, that's so different from a desired environment that it's a bad idea.

## Status

Once I was done (I actually switched to a later repo)
the versions I found myself with (held back) were:

    root@coders:~# dpkg -l | grep php
    ii  libapache2-mod-php5                 5.4.9-4ubuntu2.4
    ii  php-pear                            5.4.9-4ubuntu2.4
    ii  php5-cli                            5.4.9-4ubuntu2.4
    ii  php5-common                         5.4.9-4ubuntu2.4
    ii  php5-gd                             5.4.9-4ubuntu2.4
    ii  php5-mysql                          5.4.9-4ubuntu2.4
    root@coders:~# dpkg -l | grep apache
    ii  apache2-mpm-prefork                 2.2.22-6ubuntu5.1
    ii  apache2-utils                       2.2.22-6ubuntu5.1
    ii  apache2.2-bin                       2.2.22-6ubuntu5.1
    ii  apache2.2-common                    2.2.22-6ubuntu5.1
    ii  libapache2-mod-php5                 5.4.9-4ubuntu2.4
