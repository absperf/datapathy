class Observation
  include Datapathy::Model
  include Datapathy::Model::MultiFinder

  service_type :measurements

  persists :timestamp, :value, :status

  links_to :metric
  links_to :host
  links_to :agent
end
