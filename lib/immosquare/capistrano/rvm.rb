require_relative "defaults"

##============================================================##
## We load rvm tasks
##============================================================##
load File.expand_path("tasks/rvm.rake", __dir__)

##============================================================##
## cap stage xxx
## Exemple : cap production deploy
## we launch task just after the stage is loaded
##============================================================##
Capistrano::DSL.stages.each do |stage|
  after stage, "rvm:hook"
end
