
##============================================================##
## We load github tasks
##============================================================##
load File.expand_path("tasks/github.rake", __dir__)

##============================================================##
## Setup github hooks.
##============================================================##
before "deploy:starting", "github:setup"
