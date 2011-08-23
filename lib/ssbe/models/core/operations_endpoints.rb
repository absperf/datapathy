class OperationsEndpoints
  def self.[](name)
    all[name]
  end

  def self.all
    @all_resources ||= resources.each_with_object(HashWithIndifferentAccess.new) { |resource, hash| hash[resource.name] = resource.href }
  end

  def self.keys
    all.keys
  end

  private

  def self.service_descriptor
    @service_descriptor ||= ServiceDescriptor[:operations]
  end

  def self.resources
    @resources ||= service_descriptor.resources
  end
end
