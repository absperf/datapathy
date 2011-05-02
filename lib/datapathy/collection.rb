class Datapathy::Collection

  attr_reader :query, :model

  attr_accessor :href

  def initialize(model)
    @model = model
    @query = Datapathy::Query.new

    @elements = []
  end

  def href
    @href ||= ServiceDescriptor.discover(model)
  end

  def create(attrs = {})
    resource = model.new(attrs)
    resource.collection = self
    resource.create
  end

  def detect(*attrs, &blk)
    slice(0, 1)
    select(*attrs, &blk)
    to_a.first
  end
  alias find detect
  alias first detect

  def select(*attrs, &blk)
    query.add(*attrs, &blk)
    self
  end
  alias find_all select

  def slice(index_or_start_or_range, length = nil)
    if index_or_start_or_range.is_a?(Range)
      range = index_or_start_or_range
      count, offset = (range.last - range.first), range.first
    elsif length
      start = index_or_start_or_range
      count, offset = length, start
    else
      count, offset = 1, index_or_start_or_range
    end

    query.limit(count, offset)
  end

  def loaded?
    !@elements.empty?
  end

  def replace(records)
    elements = records[:items].map { |r| model.new(r) }
    self.href = records[:href]
    @elements.replace query.filter elements
    self
  end

  def to_a
    self.load! unless loaded?
    @elements
  end

  def to_json
    to_a.to_json
  end

  def load!
    Datapathy.instrumenter.instrument('request.datapathy', :href => @href || model && model.resource_name, :action => :read) do
      model.adapter.read(self)
    end
  end

  # Since @elements is an array, pretty much every array method should trigger
  # a load. The exceptions are the ones defined above.
  TRIGGER_METHODS = (Array.instance_methods - self.instance_methods).freeze
  TRIGGER_METHODS.each do |meth|
    class_eval <<-EVAL, __FILE__, __LINE__
      def #{meth}(*a, &b)
        self.load! unless loaded?
        @elements.#{meth}(*a, &b)
      end
    EVAL
  end

end
