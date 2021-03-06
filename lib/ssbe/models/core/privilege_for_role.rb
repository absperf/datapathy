
class PrivilegeForRole
  include Datapathy::Model

  service_type :kernel

  persists :privilege_href

  def privilege
    Privilege.at(privilege_href)
  end
end
