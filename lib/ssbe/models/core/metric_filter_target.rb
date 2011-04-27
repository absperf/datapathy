class MetricFilterTarget
  include Datapathy::Model

  service_type :measurements
  resource_name :AllMetricFilterTargets

  persists :name, :target, :valid_comparisons

end

