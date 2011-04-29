module AdapterHelper

  def with_adapter(adapter, &block)
    describe "when using #{adapter} adapter", :adapter => adapter do
      before do
        Datapathy.adapter = Datapathy.adapters[adapter]
      end

      instance_eval &block
    end
  end

  def each_adapter(&block)
    [:memory, :ssbe].each do |adapter|
      with_adapter adapter, &block
    end
  end

  RSpec.configure { |c| c.extend self }
end


