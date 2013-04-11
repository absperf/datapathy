class NotificationResult
  include Datapathy::Model

  service_type :escalation

  links_to :escalation
  links_to :address

  persists :notification_at, :result, :success, :created_at

end
