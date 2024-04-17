module Capistrano
  module SolidQueue
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

      def self.service_name
        "#{fetch(:solid_queue_service_unit_name)}.service"
      end

      def self.result_path
        "#{fetch(:tmp_dir)}/#{service_name}"
      end
    end
  end
end
