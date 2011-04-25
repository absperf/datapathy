require 'spec_helper'

describe Datapathy::Adapters::MemoryAdapter do
  before do
    @adapter = Datapathy::Adapters::MemoryAdapter.new
  end

  after do
    @adapter.clear!
  end

  subject { @adapter }

  describe "#post" do
    before do
      @resource = @adapter.post("/hosts", {:hostname => "example.com"} )
    end

    subject { @resource }

    it { should_not be_nil }
    it { should have_attributes :hostname => "example.com", :href => %r{/hosts/\d+} }
  end

  describe "#get" do
    before do
      @created_resource = @adapter.post("/hosts", {:hostname => "example.com"} )
    end

    subject { @resource }

    context "single record" do
      before do
        @href = @created_resource[:href]
        @resource = @adapter.get(@href)
      end

      it { should_not be_nil }
      it { should have_attributes :href => @href, :hostname => "example.com" }
    end

    context "collection" do
      before do
        @resource = @adapter.get("/hosts")
      end

      it { should_not be_nil }
      it { should have_attributes :href => "/hosts", :item_count => 1, :items => Array }
    end
  end

  describe "#put" do
    before do
      @original_resource = @adapter.post("/hosts", {:hostname => "example.com"} )
      attrs = @original_resource.merge(:hostname => "foo.example.com")
      @resource = @adapter.put(@original_resource[:href], attrs)
    end

    subject { @resource }

    it { should_not be_nil }
    it { should have_attributes :hostname => "foo.example.com", :href => @original_resource[:href] }
  end

  describe "#delete" do
    before do
      @resource = @adapter.post("/hosts", {:hostname => "example.com"} )
      @resource = @adapter.delete(@resource[:href])
    end

    subject { @resource }

    context 'returning the deleted resource' do
      it { should_not be_nil }
    end

    context 'trying to get it later' do
      before do
        @resource = @adapter.get(@resource[:href])
      end

      it { should be_nil }
    end

  end

  RSpec::Matchers.define :have_attributes do |attrs|
    match do |obj|
      attrs.all? do |k,v|
        case v
        when Class
          obj[k].is_a? v
        when Regexp
          obj[k] =~ v
        else
          obj[k] == v
        end
      end
    end
  end
end
