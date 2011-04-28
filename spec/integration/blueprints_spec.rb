require 'spec_helper'

describe "Blueprints" do

  each_adapter do

    [Client, Host, MetricType, Metric, MetricFilter].each do |klass|

      describe "#{klass}.make" do
        subject { lambda { klass.make } }

        it { klass.make; should_not raise_error }
      end
    end

  end
end

