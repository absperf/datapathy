# only require the parts of activesupport we want
require 'active_support/inflector'
require 'active_support/core_ext/string/inflections'
require 'datapathy/inflections'
require 'logger'

module Datapathy

  class RecordNotFound < Exception; end
  class RecordInvalid < Exception
    attr_reader :record, :errors
    def initialize(record)
      @record = record
      @errors = record.errors
      messages = errors.full_messages.join(', ')
      super(messages)
    end
  end

  def self.adapters
    @adapters ||= {
      :default => Datapathy::Adapters::MemoryAdapter.new
    }
  end

  def self.default_adapter
    adapters[:default]
  end

  def self.adapter
    @adapter || adapters[:default]
  end

  def self.adapter= adapter
    @adapter = adapter
  end

  def self.instrumenter
    @instrumenter ||= ActiveSupport::Notifications.instrumenter
  end

  def self.logger
    @logger || ::Logger.new(nil)
  end

  def self.logger= logger
    @logger = logger
  end
end

$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'datapathy/version'
require 'datapathy/log_subscriber'
require 'datapathy/model'
require 'datapathy/query'
require 'datapathy/collection'
require 'datapathy/adapters/abstract_adapter'
require 'datapathy/adapters/memory_adapter'
require 'datapathy/adapters/ssbe_adapter'
require 'datapathy/adapters/ssbe_vcr_adapter'

if defined?(Rails)
  require 'datapathy/railtie'
end
