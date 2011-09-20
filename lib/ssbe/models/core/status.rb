class Status
  include Datapathy::Model

  service_type :measurements

  persists :value, :last_updated, :status

  links_to :metric
end
