
module Datapathy::Model
  module Links
    extend ActiveSupport::Concern

    module ClassMethods

      def links
        @links ||= []
      end

      def links_to(name, options = {})
        define_link_to :single, name, options
      end

      def links_to_collection(name, options = {})
        define_link_to :collection, name, options
      end

      protected

      def define_link_to(single_or_collection, name, options = {})
        link_name = [name, "href"].join('_').to_sym
        class_name = options[:class_name] || name.to_s.classify
        lookup_method = single_or_collection == :single ? :at : :from

        persists link_name

        links << link_name

        self.class_eval <<-CODE, __FILE__, __LINE__
          def #{name}(params = {})
            unless #{link_name}.nil?
              if params.is_a? Datapathy::Model
                param_name = params.model.to_s.underscore.singularize + "_href"
                params = {param_name => params.href}
              end
              @#{name} ||= #{class_name}.#{lookup_method}(#{link_name}, params)
            end
          end
        CODE

        if single_or_collection == :single
          self.class_eval <<-CODE, __FILE__, __LINE__
            def #{name}=(resource)
              @#{name} = resource
              merge(:#{link_name} => resource.href)
              resource
            end
          CODE
        end

      end

    end

  end
end
