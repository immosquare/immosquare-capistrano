namespace :puma do
  ##============================================================##
  ## Install puma service
  ##============================================================##
  desc "Install puma service"
  task :install do
    on roles(:app) do
      template_path = File.read(Capistrano::Immosquare::Helpers.template_path("puma"))
      result        = ERB.new(template_path).result(binding)
      result_path   = Capistrano::Immosquare::Helpers.result_path("puma")
      service_name  = Capistrano::Immosquare::Helpers.service_name("puma")

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
  ## Uninstall puma service
  ##============================================================##
  desc "Uninstall puma service"
  task :uninstall do
    on roles(:app) do
      service_name = Capistrano::Immosquare::Helpers.service_name("puma")

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
  ## Start puma
  ##============================================================##
  desc "Start puma"
  task :start do
    on roles(:app) do
      sudo "systemctl start #{Capistrano::Immosquare::Helpers.service_name("puma")}"
    end
  end

  ##============================================================##
  ## Stop puma (force immediate termination)
  ##============================================================##
  desc "Stop puma (force immediate termination)"
  task :stop do
    on roles(:app) do
      sudo "systemctl stop #{Capistrano::Immosquare::Helpers.service_name("puma")}"
    end
  end

  ##============================================================##
  ## Restart puma
  ##============================================================##
  desc "Restart puma"
  task :restart do
    on roles(:app) do
      sudo "systemctl restart #{Capistrano::Immosquare::Helpers.service_name("puma")}"
    end
  end

  ##============================================================##
  ## Reload puma
  ##============================================================##
  desc "Roload puma"
  task :reload do
    on roles(:app) do
      service_ok = execute("systemctl status #{Capistrano::Immosquare::Helpers.service_name("puma")} > /dev/null", :raise_on_non_zero_exit => false)
      sudo "systemctl #{service_ok ? "reload" : "restart"} #{Capistrano::Immosquare::Helpers.service_name("puma")}"
    end
  end


  ##============================================================##
  ## Smart restart puma (with phased restart if enabled)
  ##============================================================##
  desc "Smart restart puma (with phased restart if enabled)"
  task :smart_restart do
    invoke fetch(:puma_phased_restart) ? "puma:reload" : "puma:restart"
  end
end
