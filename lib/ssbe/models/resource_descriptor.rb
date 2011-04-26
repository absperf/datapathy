
class ResourceDescriptor
  include Datapathy::Model

  persists :name

  def self.[](name)
    self.select { |m|
      m.name == name
    }
  end
end
