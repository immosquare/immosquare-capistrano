namespace :rvm do
  task :hook do
    on roles(:app) do
      rvm_system_path = "/usr/local/rvm"
      rvm_user_path   = "~/.rvm"

      ##============================================================##
      ## Check if the RVM Ruby version is set
      ##============================================================##
      rvm_path =
        if test("[ -d #{rvm_user_path} ]")
          rvm_user_path
        elsif test("[ -d #{rvm_system_path} ]")
          rvm_system_path
        else
          raise("RVM path not found on server. Please install RVM first")
        end

      ##============================================================##
      ## Log
      ##============================================================##
      info "RVM path detected: #{rvm_path}"


      ##============================================================##
      ## Set the RVM command map
      ##============================================================##
      SSHKit.config.command_map[:rvm] = "#{rvm_path}/bin/rvm"

      ##============================================================##
      ## Set the RVM prefix for the commands
      ##============================================================##
      fetch(:rvm_map_bins).each do |command|
        SSHKit.config.command_map.prefix[command.to_sym].unshift("#{rvm_path}/bin/rvm #{fetch(:rvm_ruby_version)} do")
      end
    end
  end
end
