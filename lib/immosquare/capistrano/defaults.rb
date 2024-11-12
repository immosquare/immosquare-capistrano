namespace :load do
  task :defaults do
    ##============================================================##
    ## Puma
    ##============================================================##
    set_if_empty :puma_service_unit_name,        -> { "puma_#{fetch(:application)}_#{fetch(:stage)}" }

    ##============================================================##
    ## Sidekiq
    ##============================================================##
    set_if_empty :sidekiq_service_unit_name,     -> { "sidekiq_#{fetch(:application)}_#{fetch(:stage)}" }

    ##============================================================##
    ## SolidQueue
    ##============================================================##
    set_if_empty :solid_queue_service_unit_name, -> { "solid_queue_#{fetch(:application)}_#{fetch(:stage)}" }

    ##============================================================##
    ## rvm
    ##============================================================##
    set_if_empty :rvm_ruby_version,  -> { "default" }
    set_if_empty :rvm_map_bins,      -> { ["gem", "rake", "ruby", "bundle"] }
  end
end
