require_relative "defaults"
require_relative "helpers"

##============================================================##
## We load solid_queue tasks
##============================================================##
load File.expand_path("tasks/solid_queue.rake", __dir__)


##============================================================##
## SolidQueue hooks
##============================================================##
after "deploy:starting",  "solid_queue:stop"
after "deploy:published", "solid_queue:start"
after "deploy:failed",    "solid_queue:restart"
