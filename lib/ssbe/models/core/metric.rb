
class Metric < SsbeModel

  service_type :measurements

  persists :path, :metric_type, :active, :status, :value, :historical_observations_href, :active?

  links_to :subject, :class_name => "Host"
  links_to :metric_type
  links_to_collection :observations
  links_to_collection :matching_filters, :class_name => "MetricFilter"

  def name
    metric_type["path"]
  end

  def create
    host.metrics.create(self)
  end

end
