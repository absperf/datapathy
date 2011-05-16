class RoleAssignment
  include Datapathy::Model

  service_type :kernel

  persists :created_at, :deactivated_at

  links_to :client
  links_to :role
  links_to :account

end

