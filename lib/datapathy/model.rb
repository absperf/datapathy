require 'active_support/concern'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/module/attribute_accessors'

require 'active_model'

require 'datapathy/query'

require 'datapathy/model/crud'
require 'datapathy/model/discovery'
require 'datapathy/model/dynamic_finders'
require 'datapathy/model/links'

module Datapathy::Model
  extend ActiveSupport::Concern
  extend ActiveModel::Naming

  include ActiveModel::Conversion
  include ActiveModel::Serialization

  include ActiveModel::Validations

  include Datapathy::Model::Crud
  include Datapathy::Model::Discovery
  include Datapathy::Model::DynamicFinders
  include Datapathy::Model::Links

  attr_reader :attributes
  attr_accessor :collection

  included do
    persists :href, :created_at, :updated_at
  end

  def initialize(attrs = {})
    @attributes = HashWithIndifferentAccess.new(:_type => _type)
    attrs.each do |key,val|
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      else
        attributes[key] = val
      end
    end
  end

  def [](key)
    attributes[key]
  end

  def []=(key, value)
    attributes[key] = value
  end

  def merge!(attrs = {})
    attrs.each do |key,val|
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      else
        attributes[key] = val
      end
    end
  end
  alias merge merge!

  def model
    self.class
  end

  def _type
    model.to_s
  end
  alias type _type

  def ==(other)
    self.href == (other && other.href)
  end

  def new_record?
    !self.href
  end

  def collection
    @collection ||= Datapathy::Collection.new(self)
  end

  def adapter
    self.class.adapter
  end

  def inspect
    "#<#{self.class.to_s}:#{object_id} #{attributes.inspect}>"
  end

  #override the ActiveModel::Validations one, because its dumb
  def valid?
    _run_validate_callbacks if errors.empty?
    errors.empty?
  end

  def created_at=(iso8601_time)
    merge :created_at => Time.iso8601(iso8601_time)
  end

  def updated_at=(iso8601_time)
    merge :updated_at => Time.iso8601(iso8601_time)
  end

  def serializable_hash(options = nil)
    attributes
  end

  def as_json(*a)
    serializable_hash(*a)
  end

  module ClassMethods

    def persists(*args)
      attributes.push(*args)
      args.each do |name|
        name = name.to_s.gsub(/\?\Z/, '')
        define_getter_method(name)
        define_setter_method(name)
      end
    end

    def define_getter_method(name)
      class_eval <<-CODE
        def #{name}
          attributes[:#{name}]
        end
        alias #{name}? #{name}
      CODE
    end

    def define_setter_method(name)
      class_eval <<-CODE
        def #{name}=(val)
          attributes[:#{name}] = val
        end
      CODE
    end

    def attributes
      @attributes ||= []
    end

    def new_from_attributes(attributes = {})
      m = allocate
      m.merge!(attributes = {})
      m
    end

    def adapter
      @adapter || Datapathy.adapter
    end

    def model
      self
    end

  end

end

