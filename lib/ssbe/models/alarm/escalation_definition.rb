class EscalationDefinition
  include Datapathy::Model

  service_type :escalations
  resource_name :ActiveEscalationDefinitions

  persists :active

  links_to :client
  links_to :filter, :class_name => 'MetricFilter'
  links_to_collection :escalations

  def self.make(*args)
    attrs = plan(*args)
    create(attrs)
  end
end
