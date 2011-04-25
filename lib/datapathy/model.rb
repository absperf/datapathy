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

module Datapathy::Model
  extend ActiveSupport::Concern
  extend ActiveModel::Naming

  include ActiveModel::Conversion

  include ActiveModel::Validations

  include Datapathy::Model::Crud
  include Datapathy::Model::Discovery
  include Datapathy::Model::DynamicFinders

  attr_reader :attributes

  included do
    persists :href
  end

  def initialize(attrs = {})
    @attributes = HashWithIndifferentAccess.new
    merge!(attrs)
    @new_record = true
  end

  def [](key)
    attributes[key]
  end

  def []=(key, value)
    attributes[key] = value
  end

  def merge(attrs = {})
    attributes.merge attrs
  end

  def merge!(attrs = {})
    attributes.merge! attrs
  end

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
    @new_record
  end

  def adapter
    self.class.adapter
  end

  #override the ActiveModel::Validations one, because its dumb
  def valid?
    _run_validate_callbacks if errors.empty?
    errors.empty?
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
      m.new_record = false
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

