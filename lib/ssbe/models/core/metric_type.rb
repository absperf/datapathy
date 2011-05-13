
class MetricType
  include Datapathy::Model

  service_type :measurements
  resource_name :AllMetricTypes

  persists :name, :path, :stereotype

  links_to_collection :metrics

end
