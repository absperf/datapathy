require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/array/wrap'

module Datapathy::Adapters

  class MemoryAdapter < AbstractAdapter

    def initialize(options = {})
      super
    end

    def create(model)
      model.href ||= generate_href(model)
      records_for(model)[model.href] = model.attributes
      model
    end

    def read(model_or_collection)
      if model_or_collection.is_a? Datapathy::Model
        model = model_or_collection
        if attrs = records_for(model)[model.href]
          model.merge! attrs
        else
          raise Datapathy::RecordNotFound
        end
      else
        collection = model_or_collection
        records = records_for(collection.model).values
        collection.replace(
          :href       => "http://example.com/#{collection.model.to_s}",
          :item_count => records.size,
          :items      => records
        )
      end
    end

    def update(model)
      records_for(model)[model.href] = model.attributes
      model
    end

    def delete(model)
      records_for(model).delete(model.href)
      model
    end

    def records_for(model)
      datastore[model.is_a?(Class) ? model : model.class]
    end

    def datastore
      @datastore ||= Hash.new { |h,k| h[k] = {} }
    end

    def clear!
      @datastore = nil
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

