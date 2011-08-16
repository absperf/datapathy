class Revision
  include Datapathy::Model

  service_type :webwalk

  persists :step_count
  links_to :configuration
end
