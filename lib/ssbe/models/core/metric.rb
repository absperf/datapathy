
class Metric
  include Datapathy::Model

  service_type :measurements

  persists :path, :metric_type, :active, :status, :value, :historical_observations_href, :active?

  links_to :host
  #links_to :metric_type  # NOTE: collides with {metric_type} hash embedded in metric document
  links_to_collection :observations
  links_to_collection :matching_filters, :class_name => "MetricFilter"

  def self.make(*args)
    attrs = plan(*args)
    host = attrs[:host]
    host.metrics.create(attrs)
  end

end
