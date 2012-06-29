
class MetricFilter
  include Datapathy::Model
  include Datapathy::Model::MultiFinder

  service_type  :measurements
  resource_name :AllMetricFilters

  persists :purpose, :any_or_all, :criteria
  define_attribute_accessor :hosts_href

  links_to :client
  links_to_collection :metrics

  validates_presence_of :client_href
  validates_presence_of :purpose, :any_or_all
  validates_inclusion_of :any_or_all, :in => ["any", "all"]

  validates_presence_of :criteria
  validate :valid_criteria

  def any?
    any_or_all == "any"
  end

  def all?
    !any?
  end

  def criteria
    attributes[:criteria] ||= []
    if attributes[:criteria].first.is_a?(Hash)
      attributes[:criteria].map!{ |c| Criterion.new(c) }
    end
    attributes[:criteria]
  end

  def criteria_attributes=(attributes)
    criteria = []
    attributes.each do |i, values|
      next if values[:_delete] && values[:_delete].to_i == 1
      criteria << Criterion.new(values.merge(:id => i))
    end

    self.criteria = criteria
  end

  protected

  def valid_criteria
    criteria.each do |c|
      errors.add(:criteria, :invalid) unless c.valid?
    end
  end

  class Criterion
    include ActiveModel::Validations

    attr_accessor :id, :target, :comparison, :pattern

    attr_accessor :_delete # Virtual attribute for form remove

    validates_presence_of :target,
                          :comparison,
                          :pattern,
                          :message => "is required"
    validate :comparison_valid_for_target

    def initialize(attrs = {})
      attrs.each do |k,v|
        send(:"#{k}=", v)
      end
    end

    def to_json
      {
        :target => target,
        :comparison => comparison,
        :pattern => pattern
      }.to_json
    end

    def valid_comparisons
      MetricFilterTarget.all.detect { |comparisons|
        comparisons["target"] == target
      }["valid_comparisons"]
    end

    def human_target
      HUMAN_TARGETS[target]
    end

    def human_comparison
      comparison.titlecase
    end

    def new_record?; false; end
    def persisted?;  false;  end

    def self.const_missing(const)
      if const == :HUMAN_TARGETS
        human_targets = {}.tap do |targets|
          MetricFilterTarget.all.each { |target|
            targets[target[:target]] = target[:name].split('(').first
          }
        end
        const_set :HUMAN_TARGETS, human_targets
      else
        super
      end
    end

    protected

    def comparison_valid_for_target
      if !target.blank? && !valid_comparisons.include?(comparison)
        errors.add(:comparison, "\"#{human_comparison}\" is not valid for #{human_target}")
      end
    end

  end

end
