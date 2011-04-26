require 'spec_helper'

describe 'reading models' do

  before do
    @record_a = @record = Article.create(:title => "Datapathy is amazing!", :text => "It really is!")
    @record_b =           Article.create(:title => "Datapathy is awesome!", :text => "Try it today!")
    @record_c =           Article.create(:title => "Datapathy is awesome!", :text => "Title is same, but text is different")

    @records = [@record_a, @record_b, @record_c]
  end

  describe 'Model.all' do
    before do
      @articles = Article.all
    end

    it 'should retrive all records' do
      @articles.should have(@records.size).items
    end
  end

  describe 'Model.[]' do
    before do
      @article = Article[@record[:href]]
    end

    it 'should retrive it by key' do
      @article.should_not be_nil
    end

    it 'should load the attributes' do
      [:href, :title, :text].each do |atr|
        @article.send(atr).should eql(@record[atr])
      end
    end

    it 'should raise an exception if the record is not found' do
      lambda {
        @article = Article["http://example.com/none"]
      }.should raise_error(Datapathy::RecordNotFound)
    end
  end

  describe 'Model.detect' do
    before do
      @article = Article.detect { |a| a.title == @record_b[:title] }
    end

    it 'should retrieve only one record' do
      @article.should be_a(Article)
    end

    it 'should retrieve the correct record' do
      @article.title.should eql(@record_b[:title])
    end

  end
end

