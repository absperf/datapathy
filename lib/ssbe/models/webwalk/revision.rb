class Revision
  include Datapathy::Model

  service_type :webwalk

  persists :step_count

  links_to :configuration
  links_to :created_by, :class_name => 'Account'
end
