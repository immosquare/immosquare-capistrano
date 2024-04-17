namespace :load do
  task :defaults do
    set_if_empty :sidekiq_service_unit_name,     -> { "sidekiq_#{fetch(:application)}_#{fetch(:stage)}" }
    set_if_empty :solid_queue_service_unit_name, -> { "solid_queue_#{fetch(:application)}_#{fetch(:stage)}" }
  end
end
