
# Start listing the sub-tasks
# Try to keep any task-specific logic out of here,
# just import or include the individual pps
node slave {
  require 'util-setup'
  require 'aegir-slave-setup'
}

