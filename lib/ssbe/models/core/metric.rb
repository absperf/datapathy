
class Metric < SsbeModel

  service_type :measurements

  persists :subject_href, :path, :metric_type, :metric_type_href, :active, :status, :value, :observations_href, :historical_observations_href, :matching_filters_href, :active?

  def host
    @host ||= Host.at(subject_href)
  end

  def name
    metric_type["path"]
  end

  def create
    host.metrics.create(self)
  end

end
