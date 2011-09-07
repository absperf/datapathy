class Agent
  include Datapathy::Model

  service_type :measurements
  resource_name :AllAgents

  links_to :account
  links_to :client
  links_to :host
end
