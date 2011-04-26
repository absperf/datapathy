
class Privilege < SsbeModel

 service_type :kernel
 resource_name :AllPrivileges

 persists :name

 links_to_collection :roles_having_privilege, :class_name => "Role"

 def self.[](name)
   self.detect { |p| p.name == name.to_s } || raise( "Record not found: #{name}")
 end

end
