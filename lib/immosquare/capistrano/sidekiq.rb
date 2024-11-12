require_relative "defaults"
require_relative "helpers"

##============================================================##
## We load sidekiq tasks
##============================================================##
load File.expand_path("tasks/sidekiq.rake", __dir__)

##============================================================##
## Sidekiq hooks
##============================================================##
after "deploy:starting",  "sidekiq:stop"
after "deploy:published", "sidekiq:start"
after "deploy:failed",    "sidekiq:restart"
