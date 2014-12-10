notice("We will want base utilities: rsync, git etc.")

# Ensure some basic utilities are on.
# Starting from http://community.aegirproject.org/node/30

class util-setup {
  notice("Setting up base utilities: rsync, git etc.")
  package { [
      "postfix",
      "sudo",
      "rsync",
      "git-core",
      "git",
      "unzip",
      "vim",
      "tree"
    ]:
    ensure => present,
  }
}

require util-setup
