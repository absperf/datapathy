class EscalationDefinition
  include Datapathy::Model

  service_type :escalations
  resource_name :ActiveEscalationDefinitions

  persists :active
  persists :steps_attributes

  links_to :client
  links_to :filter, :class_name => 'MetricFilter'

  def metric_filter
    filter
  end

  def metric_filter=(metric_filter)
    self.filter = metric_filter
  end

  def self.make(*args)
    attrs = plan(*args)
    create(attrs)
  end
end
