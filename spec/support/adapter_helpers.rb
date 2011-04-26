module AdapterHelper

  def each_adapter(&block)
    [:memory, :ssbe].each do |adapter|
      describe "when using #{adapter} adapter", :adapter => adapter do
        before do
          Datapathy.adapter = Datapathy.adapters[adapter]
        end

        instance_eval &block
      end
    end
  end

  RSpec.configure { |c| c.extend self }
end


