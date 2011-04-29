require 'active_support/log_subscriber'
require 'active_support/notifications'

module Datapathy
  class LogSubscriber < ActiveSupport::LogSubscriber

    def self.runtime=(value)
      Thread.current["datapathy_query_runtime"] = value
    end

    def self.runtime
      Thread.current["datapathy_query_runtime"] ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end

    def request(event)
      self.class.runtime += event.duration
      debug("  [%s] %s (%.3fms) %s" %
            [
              event.payload[:action].to_s.upcase,
              event.payload[:href] || event.payload[:model].resource_name,
              event.duration,
              event.payload[:model] ? event.payload[:model].inspect : ""
            ]
           )
    end

  end
end

Datapathy::LogSubscriber.attach_to :datapathy
