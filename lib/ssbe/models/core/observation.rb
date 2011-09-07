class Observation
  include Datapathy::Model

  service_type :measurements

  persists :timestamp, :value, :status

  links_to :metric
  links_to :host
  links_to :agent
end
