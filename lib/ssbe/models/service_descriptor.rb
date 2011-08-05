class ServiceDescriptor
  include Datapathy::Model

  service_type :kernel

  persists :service_type

  def self.[](name)
    if @services && service = @services[name]
      return service
    end

    @services ||= {}

    service_type = ServiceIdentifiers[name].service_type
    result = self.detect { |m| m.service_type == service_type }

    @services[name] = result
  end

  def name
    identifier.name
  end

  def mime_type
    identifier.mime_type
  end

  def resources
    ResourceDescriptor.from(href)
  end

  def resource_for(resource_name)
    if @resources && resource = @resources[resource_name]
      return resource
    end

    @resources ||= {}
    result = resources.detect { |r| r.name == resource_name.to_s }
    @resources[resource_name] = result
  end

  def self.register(name, href)
    service_type = ServiceIdentifiers[name].service_type
    create(:service_type => service_type,
           :href         => href)
  end

  def self.discover(model_or_service_type, resource_name = nil)
    if model_or_service_type.is_a?(Datapathy::Model) ||
      (model_or_service_type.respond_to?(:ancestors) && model_or_service_type.ancestors.include?(Datapathy::Model))
      service_type  = model_or_service_type._service_type
      resource_name = model_or_service_type._resource_name
    else
      service_type  = model_or_service_type
    end

    service_descriptor  = ServiceDescriptor[service_type]
    resource_descriptor = service_descriptor.resource_for(resource_name)
    resource_descriptor.href
  end

  protected

  def identifier
    @identifier ||= ServiceIdentifiers[service_type]
  end

  class ServiceIdentifiers

    def self.[](name_or_type)
      IDENTIFIERS.detect { |i| i.name == name_or_type || i.service_type == name_or_type }
    end

    require 'ostruct'
    class ServiceIdentifier < OpenStruct; end

    IDENTIFIERS = [
      ServiceIdentifier.new(
        :name                  => :kernel,
        :service_type          => "http://systemshepherd.com/services/kernel",
        :mime_type             => "application/vnd.absperf.sskj1+json"
      ),
      ServiceIdentifier.new(
        :name                  => :measurements,
        :service_type          => "http://systemshepherd.com/services/measurements",
        :mime_type             => "application/vnd.absperf.ssmj1+json"
      ),
      ServiceIdentifier.new(
        :name                  => :escalations,
        :service_type          => "http://systemshepherd.com/services/escalations",
        :mime_type             => "application/vnd.absperf.ssaj1+json"
      ),
      ServiceIdentifier.new(
        :name                  => :message_queues,
        :service_type          => "http://systemshepherd.com/services/message-queues",
        :mime_type             => "application/vnd.absperf.sskj1+json"
      ),
      ServiceIdentifier.new(
        :name                  => :issues,
        :service_type          => "http://systemshepherd.com/services/issues",
        :mime_type             => "application/vnd.absperf.ssj1+json"
      ),
      ServiceIdentifier.new(
        :name                  => :configurator,
        :service_type          => "http://systemshepherd.com/services/configurator",
        :mime_type             => "application/vnd.absperf.sscj1+json"
      ),
      ServiceIdentifier.new(
        :name                  => :webwalk,
        :service_type          => "http://systemshepherd.com/services/webwalk",
        :mime_type             => "application/vnd.absperf.sswj1+json"
      )
    ].freeze
  end
end
