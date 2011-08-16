class Location
  include Datapathy::Model

  service_type :webwalk
  resource_name :Locations

  persists :name, :description, :active

  links_to_collection :configurations
end
