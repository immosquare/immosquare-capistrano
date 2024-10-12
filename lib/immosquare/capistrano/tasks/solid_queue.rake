namespace :solid_queue do
  ##============================================================##
  ## Install SolidQueue service
  ##============================================================##
  desc "Install SolidQueue service"
  task :install do
    on roles(:app) do
      template_path = File.read(Capistrano::Immosquare::Helpers.template_path("solid_queue"))
      result        = ERB.new(template_path).result(binding)
      result_path   = Capistrano::Immosquare::Helpers.result_path("solid_queue")
      service_name  = Capistrano::Immosquare::Helpers.service_name("solid_queue")

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
  ## Uninstall SolidQueue service
  ##============================================================##
  desc "Uninstall SolidQueue service"
  task :uninstall do
    on roles(:app) do
      service_name = Capistrano::Immosquare::Helpers.service_name("solid_queue")

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
  ## Start solid_queue
  ##============================================================##
  desc "Start solid_queue"
  task :start do
    on roles(:app) do
      sudo "systemctl start #{Capistrano::Immosquare::Helpers.service_name("solid_queue")}"
    end
  end

  ##============================================================##
  ## Stop solid_queue (force immediate termination)
  ##============================================================##
  desc "Stop solid_queue (force immediate termination)"
  task :stop do
    on roles(:app) do
      sudo "systemctl stop #{Capistrano::Immosquare::Helpers.service_name("solid_queue")}"
    end
  end

  ##============================================================##
  ## Restart solid_queue
  ##============================================================##
  desc "Restart solid_queue"
  task :restart do
    on roles(:app) do
      sudo "systemctl restart #{Capistrano::Immosquare::Helpers.service_name("solid_queue")}"
    end
  end
end
