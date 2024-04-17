
namespace :solid_queue do
  ##============================================================##
  ## Install SolidQueue service
  ##============================================================##
  task :install do
    desc "Install SolidQueue service"
    on roles(:app) do
      template_path = File.read(Capistrano::SolidQueue::Helpers.template_path("solid_queue"))
      result        = ERB.new(template_path).result(binding)
      result_path   = Capistrano::SolidQueue::Helpers.result_path

      ##============================================================##
      ## Upload the service file to the server
      ##============================================================##
      upload!(StringIO.new(result), result_path)

      ##============================================================##
      ## Move the service file to the systemd directory
      ##============================================================##
      sudo "mv #{result_path} /etc/systemd/system/#{Capistrano::SolidQueue::Helpers.service_name}"

      ##============================================================##
      ## Reload the systemd daemon and restart the service
      ##============================================================##
      sudo "systemctl daemon-reload"
      sudo "systemctl enable #{Capistrano::SolidQueue::Helpers.service_name}"
    end
  end

  desc "Uninstall SolidQueue service"
  task :uninstall do
    on roles(:app) do
      service_name = Capistrano::SolidQueue::Helpers.service_name
      sudo "systemctl stop #{service_name}"
      sudo "systemctl disable #{service_name}"
      sudo "rm -f /etc/systemd/system/#{service_name}"
      sudo "systemctl daemon-reload"
    end
  end
end
