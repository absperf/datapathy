require 'spec_helper'


describe MetricFilter do
  each_adapter do

    describe "creating" do
      before do
        @metric_filter = MetricFilter.make

        if example.metadata[:adapter] == :memory
          MetricFilterTarget.create(
            :name => "Hostname",
            :target => "Hostname",
            :valid_comparisons => [ "is", "is_not", "matches", "does_not_match" ]
          )
        end
      end

      subject { @metric_filter }

      it { should_not be_new_record }
      it { should_not have_errors }
      it { should have_attribute(:href) }

    end

  end
end
