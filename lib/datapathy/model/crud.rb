require 'addressable/template'

module Datapathy::Model
  module Crud

    extend ActiveSupport::Concern

    def save
      if new_record?
        create
      else
        update
      end
    end

    def create
      Datapathy.instrumenter.instrument('request.datapathy', :href => href, :model => self, :action => :create) do
        adapter.create(self)
        raise Datapathy::RecordInvalid, self unless valid?
        new_record = false
        self
      end
    end

    def update
      Datapathy.instrumenter.instrument('request.datapathy', :href => href, :model => self, :action => :update) do
        adapter.update(self)
      end
    end

    def delete
      Datapathy.instrumenter.instrument('request.datapathy', :href => href, :action => :delete) do
        adapter.delete(self)
      end
    end

    module ClassMethods

      def create(attrs = {})
        model = self.new(attrs)
        model.create
      end

      def [](href, params = {})
        at(href, params = {}) || raise(Datapathy::RecordNotFound)
      end

      def at(href, params = {})
        model = self.new
        href = Addressable::Template.new(href).expand(params) unless params.empty?
        model.href = href
        Datapathy.instrumenter.instrument('request.datapathy', :href => href, :action => :read) do
          adapter.read(model)
        end
      end

      def from(href, params = {})
        collection = Datapathy::Collection.new(self)
        href = Addressable::Template.new(href).expand(params) unless params.empty?
        collection.href = href
        collection
      end

      def select(*attrs, &blk)
        Datapathy::Collection.new(self).select(*attrs, &blk)
      end
      alias all select
      alias find_all select

      def detect(*attrs, &blk)
        select(*attrs, &blk).first
      end
      alias first detect
      alias find detect

    end

  end

end
