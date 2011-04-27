
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
      adapter.create(self)
      new_record = false
      self
    end

    def update
      adapter.update(self)
    end

    def delete
      adapter.delete(self)
    end

    module ClassMethods

      def create(attrs = {})
        model = self.new(attrs)
        model.save
      end

      def [](href, params = {})
        at(href, params = {}) || raise(Datapathy::RecordNotFound)
      end

      def at(href, params = {})
        model = self.new
        href = Addressable::Template.new(href).expand(params) unless params.empty?
        model.href = href
        adapter.read(model)
      end

      def from(href, params = {})
        Datapathy.instrumenter.instrument('request.datapathy', :href => href, :model => self.class.to_s) do
          collection = Datapathy::Collection.new(self)
          href = Addressable::Template.new(href).expand(params) unless params.empty?
          collection.href = href
          collection
        end
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
