require 'machinist'
require 'machinist/blueprints'

module Machinist

  module SsbeModelExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def make(*args, &block)
        lathe = Lathe.run(Machinist::SsbeModelAdapter, self.new, *args)
        lathe.object.save unless Machinist.nerfed?
        lathe.object(&block)
      end

      def make_unsaved(*args)
        lathe = Lathe.run(Machinist::SsbeModelAdapter, self.new, *args)
        yield object if block_given?
        lathe.object
      end

      def plan(*args)
        lathe = Lathe.run(Machinist::SsbeModelAdapter, self.new, *args)
        lathe.assigned_attributes
      end
    end

  end

  module CollectionExtensions
    def make(*args, &block)
      lathe = Lathe.run(Machinist::SsbeModelAdapter, self.model.new, *args)
      lathe.object.save unless Machinist.nerfed?
      lathe.object(&block)
    end

    def make_unsaved(*args)
      lathe = Lathe.run(Machinist::SsbeModelAdapter, self.model.new, *args)
      yield object if block_given?
      lathe.object
    end
  end

  class SsbeModelAdapter
    def self.has_association?(object, attribute)
      object.respond_to?(:"#{attribute}_href")
    end

    def self.class_for_association(object, attribute)
      object.send(attribute).model
    end
  end

end

Datapathy::Model::ClassMethods.send(:include, Machinist::Blueprints::ClassMethods)
Datapathy::Model::ClassMethods.send(:include, Machinist::SsbeModelExtensions::ClassMethods)
Datapathy::Collection.send(:include, Machinist::CollectionExtensions)
