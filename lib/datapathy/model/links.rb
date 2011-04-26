
module Datapathy::Model
  module Links
    extend ActiveSupport::Concern

    module ClassMethods

      def links_to(name, options = {})
        define_link_to :single, name, options
      end

      def links_to_collection(name, options = {})
        define_link_to :collection, name, options
      end

      protected

      def define_link_to(single_or_collection, name, options = {})
        link_name = [name, "href"].join('_').to_sym
        class_name = name.to_s.classify
        lookup_method = single_or_collection == :single ? :at : :from

        persists link_name

        self.class_eval %{
          def #{name}
            @#{name} ||= #{class_name}.#{lookup_method}(#{link_name})
          end
        }

        if single_or_collection == :single
          self.class_eval %{
            def #{name}=(resource)
              @#{name} = resource
              merge(:#{link_name} => resource.href)
              resource
            end
          }
        end

      end

    end

  end
end
