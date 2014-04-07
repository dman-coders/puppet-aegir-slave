notice("Setting up base utilities: rsync, git etc.")

# Ensure some basic utilities are on.
# Starting from http://community.aegirproject.org/node/30

class util-setup {
  package { [
      "postfix",
      "sudo",
      "rsync",
      "git-core",
      "unzip",
    ]:
    ensure => present,
  }
}

require util-setup
