
class Role
  include Datapathy::Model

  service_type :kernel
  resource_name :AllRoles

  persists :name, :slug

  links_to_collection :privileges_for_role

  def self.[](slug)
    self.detect { |r| r.slug == slug.to_s }
  end

  def add_privileges(*privileges)
    privileges.each do |privilege_or_name|
      privilege = privilege_or_name.is_a?(Privilege) ? privilege_or_name : Privilege[privilege_or_name]

      privileges_for_role.create(:privilege_href => privilege.href)
    end
  end

end
