require_relative "defaults"
require_relative "helpers"

##============================================================##
## We load puma tasks
##============================================================##
load File.expand_path("tasks/puma.rake", __dir__)

##============================================================##
## puma hooks
##============================================================##
after "deploy:finished", "puma:smart_restart"
