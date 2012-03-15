class MetricDescription
  include Datapathy::Model

  service_type :measurements
  resource_name :AllMetricDescriptions

  persists :metric_type_pattern, :description

  validates_presence_of :metric_type_pattern
end
