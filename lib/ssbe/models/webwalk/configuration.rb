class Configuration
  include Datapathy::Model

  service_type :webwalk

  persists :application_name, :transaction_name, :description, :active

  links_to_collection :revisions
  links_to :active_revision, :class_name => 'Revision'
end
