require 'resourceful'
require 'active_support/core_ext/hash/keys'
require 'active_support/json'

require 'resourceful/ssbe_authenticator'

require 'ssbe/models/service_descriptor'
require 'ssbe/models/resource_descriptor'

module Datapathy::Adapters
  class SsbeAdapter < Datapathy::Adapters::AbstractAdapter
    attr_reader :http, :backend

    def initialize(options = {})
      super

      @backend = @options[:backend]
      @username, @password = @options[:username], @options[:password]

      @http = Resourceful::HttpAccessor.new
      @http.logger = @options[:logger] || Datapathy.logger
      @http.cache_manager = Resourceful::InMemoryCacheManager.new unless @options[:disable_cache]
      @http.add_authenticator Resourceful::SsbeAuthenticator.new(@username, @password)
    end

    def create(model)
      resource     = resource_for(model)
      record       = serialize(model)
      content_type = content_type_for(model)

      begin
        response = resource.post(record, "Content-Type" => content_type)
        model.merge!(deserialize(response)) unless response.body.blank?
      rescue Resourceful::UnsuccessfulHttpRequestError => e
        if e.http_response.code == 403
          set_errors(model, e)
        else
          raise e
        end
      end
    end

    def read(model_or_collection)
      if model_or_collection.is_a? Datapathy::Model
        model = model_or_collection
        response = resource_for(model).get
        model.merge!(deserialize(response))
        model
      else
        collection = model_or_collection
        response = resource_for(collection).get
        records = deserialize(response)
        collection.replace records
      end
    end

    def update(model)
      resource     = resource_for(model)
      record       = serialize(model)
      content_type = content_type_for(model)

      begin
        response = resource.put(record, "Content-Type" => content_type)
        model.merge!(deserialize(response)) unless response.body.blank?
      rescue Resourceful::UnsuccessfulHttpRequestError => e
        if e.http_response.code == 403
          set_errors(model, e)
        else
          raise e
        end
      end
    end

    def services_uri
      @services_uri ||= "http://core.#{backend}/service_descriptors"
    end

    protected

    def deserialize(response)
      ActiveSupport::JSON.decode(response.body.gsub('\/', '/')).symbolize_keys
    end

    def serialize(resource, attrs_for_update = {})
      attrs = resource.attributes.dup.merge(attrs_for_update)
      attrs.delete_if { |k,v| v.nil? }
      Yajl::Encoder.encode(attrs)
    end

    def resource_for(model_or_collection)
      uri = if model_or_collection.model == ServiceDescriptor
              services_uri
            elsif model_or_collection.respond_to?(:href) && href = model_or_collection.href
              href
            elsif model_or_collection.respond_to?(:collection) && collection = model_or_collection.collection
              collection.href
            end

      raise "Could not identify a location to look for #{model_or_collection}" unless uri

      if uri.is_a? Addressable::URI
        uri.scheme = 'http'
      else
        uri.gsub!(/^https:/, 'http:')
      end

      http.resource(uri, default_headers)
    end

    def content_type_for(model)
      ServiceDescriptor::ServiceIdentifiers[model._service_type].mime_type
    end

    def set_errors(model, exception)
      errors =  deserialize(exception.http_response)[:errors]
      errors.each do |field, messages|
        model.errors[field].push *messages
      end if errors
    end


    def default_headers
      @default_headers ||= {
        :accept => 'application/vnd.absperf.sskj1+json, application/vnd.absperf.ssmj1+json, application/vnd.absperf.sscj1+json, application/vnd.absperf.ssaj1+json, application/vnd.absperf.sswj1+json'
      }
    end

  end

end

