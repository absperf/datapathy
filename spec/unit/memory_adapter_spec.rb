require 'spec_helper'

describe Datapathy::Adapters::MemoryAdapter do
  before do
    @adapter = Datapathy::Adapters::MemoryAdapter.new
    @person = Person.new :name => "Paul"
  end

  after do
    @adapter.clear!
  end

  subject { @adapter }

  describe "#create" do
    before do
      @resource = @adapter.create @person
    end

    subject { @resource }

    it { should_not be_nil }
    it { should have_attributes :name => "Paul", :href => %r{/Person/\d+} }
  end

  describe "#read" do
    before do
      @created_resource = @adapter.create @person
    end

    subject { @resource }

    context "a model" do
      before do
        @resource = @adapter.read @person
      end

      it { should_not be_nil }
      it { should have_attributes :href => @created_resource.href, :name => "Paul" }
    end

    context "a collection" do
      before do
        @collection = @adapter.read Datapathy::Collection.new(Person)
      end

      subject { @collection }

      it { should_not be_empty }
      it { should have_attributes :href => "http://example.com/Person" }
    end
  end

  describe "#put" do
    before do
      @original_resource = @adapter.create @person
      @original_resource.name = "Paul Sadauskas"
      @resource = @adapter.update @original_resource
    end

    subject { @resource }

    it { should_not be_nil }
    it { should have_attributes :name => "Paul Sadauskas", :href => @original_resource[:href] }
  end

  describe "#delete" do
    before do
      @original_resource = @adapter.create @person
      @resource = @adapter.delete @person
    end

    subject { @resource }

    context 'returning the deleted resource' do
      it { should_not be_nil }
    end

    context 'trying to get it later' do
      it do
        lambda {
          @adapter.read @person
        }.should raise_error(Datapathy::RecordNotFound)
      end
    end

  end

  RSpec::Matchers.define :have_attributes do |attrs|
    match do |obj|
      attrs.all? do |key, expected_value|
        value = if obj.respond_to?(key)
                  obj.send key
                elsif obj.respond_to?(:[])
                  obj[key]
                else
                  false
                end

        case expected_value
        when Class
          value.is_a? expected_value
        when Regexp
          value =~ expected_value
        else
          value == expected_value
        end
      end
    end
  end
end
