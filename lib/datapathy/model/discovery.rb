

module Datapathy::Model
  module Discovery

    extend ActiveSupport::Concern

    def service_type
      self.class.service_type
    end

    def resource_name
      self.class.resource_name
    end

    module ClassMethods

      def service_type(service_type = nil)
        if service_type
          @service_type = service_type
        else
          @service_type
        end
      end

      def resource_name(resource_name = nil)
        if resource_name
          @resource_name = resource_name
        else
          @resource_name
        end
      end

    end
  end
end
