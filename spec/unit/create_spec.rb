require 'spec_helper'

describe "Creating models" do

  share_as :CreatingARecord do
    before do
      @record = Article[@article.href]
    end

    it 'should not be a new record anymore' do
      @article.should_not be_new_record
    end

    it 'should set the attributes on the model' do
      @article.title.should == "Datapathy is awesome!"
      @article.text.should == "It just is!"
    end

    it 'should generate the href' do
      @article.href.should_not be_nil
    end

    it 'should create a record' do
      @record.should_not be_nil
    end

    it 'should store persistable attributes' do
      @record[:href].should  eql(@article.href)
      @record[:title].should eql(@article.title)
      @record[:text].should  eql(@article.text)
    end

  end

  describe 'Model.create' do
    before do
      @article = Article.create(:title => "Datapathy is awesome!",
                                :text => "It just is!")
    end

    it_should_behave_like CreatingARecord

  end

  describe 'Model.new; #save' do
    before do
      @article = Article.new(:title => "Datapathy is awesome!",
                             :text => "It just is!")
      @article.save
    end

    it_should_behave_like CreatingARecord

  end

end
