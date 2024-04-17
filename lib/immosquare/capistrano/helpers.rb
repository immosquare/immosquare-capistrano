module Capistrano
  module Immosquare
    module Helpers
      ##============================================================##
      ## Get the path to bundle command
      ##============================================================##
      def self.expanded_bundle_command
        SSHKit.config.command_map[:bundle].to_s
      end

      def self.template_path(service)
        "#{File.dirname(__FILE__)}/templates/#{service}.service.erb"
      end

      def self.service_name(service)
        "#{fetch(:"#{service}_service_unit_name")}.service"
      end

      def self.result_path(service)
        "#{fetch(:tmp_dir)}/#{service_name(service)}"
      end
    end
  end
end
