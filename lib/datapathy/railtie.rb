require 'active_model/railtie'
require 'action_controller/railtie'

module Datapathy
  class Railtie < Rails::Railtie

    initializer "datapathy.log_runtime" do |app|
      ActiveSupport.on_load(:action_controller) do
        include Datapathy::Railties::ControllerRuntime
      end
    end
  end

  require 'active_support/core_ext/module/attr_internal'
  module Railties
    module ControllerRuntime
      extend ActiveSupport::Concern

      attr_internal :request_runtime

      def cleanup_view_runtime
        runtime_before_request = Datapathy::LogSubscriber.reset_runtime
        runtime = super
        runtime_after_request = Datapathy::LogSubscriber.reset_runtime
        self.request_runtime = runtime_before_request + runtime_after_request
        runtime - runtime_after_request
      end

      def append_info_to_payload(payload)
        super
        payload[:request_runtime] = self.request_runtime
      end

      module ClassMethods
        def log_process_action(payload)
          messages, request_runtime = super, payload[:request_runtime]
          messages << ("Datapathy: %.1fms" % request_runtime.to_f) if request_runtime
          messages
        end
      end

    end
  end

end

