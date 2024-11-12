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
          error("RVM path not found on server. Please install RVM first")
          exit(1)
        end
      info "RVM path detected: #{rvm_path}"
      rvm_bin_path = "#{rvm_path}/bin/rvm"

      ##============================================================##
      ## Set the RVM command map
      ##============================================================##
      SSHKit.config.command_map[:rvm] = rvm_bin_path

      ##============================================================##
      ## Check if the RVM Ruby version is set
      ##============================================================##
      rvm_ruby_version = fetch(:rvm_ruby_version)
      if rvm_ruby_version.nil?
        error "rvm_ruby_version not set. Please set the rvm_ruby_version in your deploy.rb file with format ruby-x.y.z@your-app-name"
        exit 1
      elsif rvm_ruby_version !~ /^ruby-\d+\.\d+\.\d+@[a-z0-9\-_]+$/i
        error "rvm_ruby_version format is invalid. Please set the rvm_ruby_version in your deploy.rb file with format ruby-x.y.z@your-app-name"
        exit 1
      end
      info "rvm_ruby_version set: #{rvm_ruby_version}"

      ##============================================================##
      ## Set the RVM prefix for the commands
      ##============================================================##
      ["gem", "rake", "ruby", "bundle"].each do |command|
        SSHKit.config.command_map.prefix[command.to_sym].unshift("#{rvm_bin_path} #{rvm_ruby_version} do")
      end


      ##============================================================##
      ## Check if ruby version is installed
      ##============================================================##
      ruby_version = rvm_ruby_version.split("@").first
      unless test("#{rvm_bin_path} #{ruby_version} do ruby --version")
        error "Ruby version #{ruby_version} is not installed on the server. Please install it first  with 'rvm install #{ruby_version}'"
        exit 1
      end
      info "#{ruby_version} is installed on the server."

      ##============================================================##
      ## Check if gemset exists, if not create it
      ##============================================================##
      gemset_name = rvm_ruby_version.split("@").last
      unless test("#{rvm_bin_path} #{rvm_ruby_version} do rvm gemset list | grep -wq #{gemset_name}")
        info "Creating gemset #{gemset_name} for #{ruby_version}"
        execute :rvm, "#{ruby_version} do rvm gemset create #{gemset_name}"
      end
    end
  end
end
