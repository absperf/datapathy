
class Role
  include Datapathy::Model

  service_type :kernel
  resource_name :AllRoles

  persists :name, :slug

  links_to_collection :privileges_for_role, :class_name => "PrivilegeForRole"

  def self.[](slug)
    self.detect { |r| r.slug == slug.to_s }
  end

  def add_privileges(*privileges)
    privileges.each do |privilege_or_name|
      privilege = privilege_or_name.is_a?(Privilege) ? privilege_or_name : Privilege[privilege_or_name]

      privileges_for_role.create(:privilege_href => privilege.href)
    end
  end

  def self.register(attrs = {})
    role = self.find_or_create_by_slug(attrs.slice(:name, :slug))

    attrs[:privileges].map do |privilege_name|
      privilege = Privilege.find_or_create_by_name(:name => privilege_name)
      p privilege
      role.add_privileges privilege unless role.privileges_for_role.include?(privilege)
    end

  end

end
