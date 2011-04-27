

module Datapathy::Model
  module Discovery

    extend ActiveSupport::Concern

    # A model (ServiceDescriptor) might have an actual attribute :service_type
    # so hide ours so we can still determine the service_descriptors content-type
    # when registering it
    def _service_type
      self.class.service_type
    end
    alias service_type _service_type

    def _resource_name
      self.class.resource_name
    end
    alias resource_name _resource_name

    module ClassMethods

      def _service_type(service_type = nil)
        if service_type
          @_service_type = service_type
        else
          @_service_type
        end
      end
      alias service_type _service_type

      def _resource_name(resource_name = nil)
        if resource_name
          @_resource_name = resource_name
        else
          @_resource_name
        end
      end
      alias resource_name _resource_name

    end
  end
end
