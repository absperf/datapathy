require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/array/wrap'

module Datapathy::Adapters

  class MemoryAdapter < AbstractAdapter

    def initialize(options = {})
      super
      clear!
    end

    def create(model)
      href = generate_href(model)
      model.href ||= href
      model.created_at = Time.now if model.class.attributes.include?(:created_at)
      model.updated_at = Time.now if model.class.attributes.include?(:updated_at)
      model.class.links.each do |link_name|
        model.attributes[link_name] ||= "#{href}/#{link_name}"
      end
      records_for(model)[model.href] = model.attributes
      model
    end

    def read(model_or_collection)
      if model_or_collection.is_a? Datapathy::Model
        model = model_or_collection
        if attrs = records_for(model)[model.href]
          model.merge! attrs
          model
        elsif attrs = datastore.values.detect { |hsh| hsh.has_key?(model.href) }[model.href]
          # If we didnt find it in our normal collection, search the whole data store
          model.merge! attrs
          model
        else
          nil
        end
      else
        collection = model_or_collection
        records = records_for(collection).values
        collection.replace(
          :href       => "http://example.com/#{collection.model.to_s}",
          :item_count => records.size,
          :items      => records
        )
      end
    end

    def update(model)
      records_for(model)[model.href] = model.attributes
      model.updated_at = Time.now if model.class.attributes.include?(:updated_at)
      model
    end

    def delete(model)
      records_for(model).delete(model.href)
      model
    end

    def records_for(model_or_collection)
      key = key_for(model_or_collection)
      datastore[key]
    end

    def key_for(model_or_collection)
      if model_or_collection.is_a?(Datapathy::Collection)
        collection = model_or_collection
        if href = collection.instance_variable_get(:@href)
          href.to_s
        else
          key_for(collection.model)
        end
      else
        model = model_or_collection
        if model.respond_to?(:collection) and href = model.collection.instance_variable_get(:@href)
          # instance_variable_get because #href triggers discovery
          href.to_s
        elsif model.respond_to?(:resource_name)
          model.resource_name
        else
          model
        end
      end

    end

    def datastore
      @datastore ||= Hash.new { |h,k| h[k] = {} }
    end

    def clear!
      @datastore = nil
      api_href = "http://example.com/clients/API"
      records_for(Client)[api_href] = {:href => api_href, :name => "API", :longname => "Absolute Performance, Inc", :active => true}
    end

    def generate_href(model)
      href = []
      href << "http://example.com"
      href << model.class.to_s
      href << (Time.now.to_f * 1_000_000).to_i
      href.join('/')
    end

  end

end

