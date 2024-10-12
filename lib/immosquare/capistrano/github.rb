require_relative "defaults"
require_relative "helpers"

load File.expand_path("tasks/github.rake", __dir__)

# github hooks
before "deploy:starting", "github:setup"
