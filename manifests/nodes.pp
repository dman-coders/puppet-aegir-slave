
# Start listing the sub-tasks
# Try to keep any task-specific logic out of here,
# just import or include the individual pps
node default {
  # Use a local proxy with apt, and run update.
  import "apt-setup"
  import "util-setup"
  import "aegir-slave-setup"
}

