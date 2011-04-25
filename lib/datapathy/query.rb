require 'active_support/basic_object'
require 'active_support/core_ext/module/delegation'

class Datapathy::Query

  attr_reader :conditions, :offset, :count

  def initialize
    @blocks = []
  end

  def add(conditions = {}, &blk)
    add_conditions_hash(conditions)
    add_conditions(&blk) if block_given?
  end

  def add_conditions(&blk)
    @blocks << blk
  end

  def add_conditions_hash(conditions = {})
    conditions.each do |k,v|
      add_conditions { |q| q.send(k) == v }
    end
  end

  def filter(resources)
    resources = match_resources(resources)
    resources = order_resources(resources)
    resources = limit_resources(resources)

    resources
  end

  def match_resources(resources)
    resources.select do |record|
      @blocks.all? do |block|
        block.call(record)
      end
    end
  end

  def order_resources(resources)
    resources
  end

  def limit_resources(resources)
    return resources unless @offset || @count
    resources.slice(@offset || 0, @count)
  end

  def limit(count, offset = 0)
    @count, @offset = count, offset
  end

  def to_s
    string = ""
    string << @blocks.inspect
    string << " limit #{@limit}" if @limit
    string << " offset #{@offset}" if @offset && @offset > 0
    string
  end

end
