module Datapathy::Model
  module AccessControl
    extend ActiveSupport::Concern

    def visible_to?(account, client_href)
      account.has_privilege_at?(self.class.view_privilege, client_href)
    end

    def modifiable_by?(account, client_href)
      account.has_privilege_at?(self.class.modify_privilege, client_href)
    end

    def creatable_by?(account, client_href)
      account.has_privilege_at?(self.class.create_privilege, client_href)
    end

    module ClassMethods
      def creatable_by?(account, client_href)
        account.has_privilege_at_any_client?(create_privilege)
      end

      def privilege_name
        @privilege_name ||= self.name.underscore
      end

      %w[view create modify].each do |action|
        class_eval <<-RUBY, __FILE__, __LINE__
        def #{action}_privilege_name
          @#{action}_privilege_name ||= "#{action}_\#{privilege_name}"
        end

        def #{action}_privilege
          @#{action}_privilege ||= Privilege[#{action}_privilege_name]
        end
        RUBY
      end
    end
  end
end
