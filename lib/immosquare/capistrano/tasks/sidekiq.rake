
namespace :sidekiq do
  ##============================================================##
  ## Install Sidekiq service
  ##============================================================##
  desc "Install Sidekiq service"
  task :install do
    on roles(:app) do
      template_path = File.read(Capistrano::Immosquare::Helpers.template_path("sidekiq"))
      result        = ERB.new(template_path).result(binding)
      result_path   = Capistrano::Immosquare::Helpers.result_path("sidekiq")
      service_name  = Capistrano::Immosquare::Helpers.service_name("sidekiq")

      ##============================================================##
      ## Upload the service file to the server
      ##============================================================##
      upload!(StringIO.new(result), result_path)

      ##============================================================##
      ## Move the service file to the systemd directory
      ##============================================================##
      sudo "mv #{result_path} /etc/systemd/system/#{service_name}"

      ##============================================================##
      ## Reload the systemd daemon and quiet the service
      ##============================================================##
      sudo "systemctl daemon-reload"
      sudo "systemctl enable #{service_name}"
    end
  end

  ##============================================================##
  ## Uninstall Sidekiq service
  ##============================================================##
  desc "Uninstall Sidekiq service"
  task :uninstall do
    on roles(:app) do
      service_name = Capistrano::Immosquare::Helpers.service_name("sidekiq")

      if test("systemctl list-units --full -all | grep -Fq '#{service_name}'")
        sudo("systemctl stop #{service_name}")
        sudo("systemctl disable #{service_name}")
        sudo("rm -f /etc/systemd/system/#{service_name}")
        sudo("systemctl daemon-reload")
      else
        info("Service #{service_name} does not exist and does not need to be disabled.")
      end
    end
  end


  ##============================================================##
  ## Start sidekiq
  ##============================================================##
  desc "Start sidekiq"
  task :start do
    on roles(:app) do
      sudo "systemctl start #{Capistrano::Immosquare::Helpers.service_name("sidekiq")}"
    end
  end

  ##============================================================##
  ## Stop sidekiq (force immediate termination)
  ##============================================================##
  desc "Stop sidekiq (force immediate termination)"
  task :stop do
    on roles(:app) do
      sudo "systemctl stop #{Capistrano::Immosquare::Helpers.service_name("sidekiq")}"
    end
  end

  ##============================================================##
  ## Restart sidekiq
  ##============================================================##
  desc "Restart sidekiq"
  task :restart do
    on roles(:app) do
      sudo "systemctl restart #{Capistrano::Immosquare::Helpers.service_name("sidekiq")}"
    end
  end
end
