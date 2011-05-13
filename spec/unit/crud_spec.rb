require 'spec_helper'

describe "CRUD API" do
  before do
    @record_foo = {:title => "Foo", :text => "foo"}
    @record_bar = {:title => "Bar", :text => "bar"}
  end

  share_as :ACollection do
    it { @result.should be_a(Datapathy::Collection) }
    it { @result.first.should be_an(Article) }
  end

  share_as :AnArticle do
    it { @result.should be_an(Article) }
  end

  describe "New" do

    share_as :NewCollection do
      it_should_behave_like ACollection
      it { @result.first.should be_new_record }
    end

    share_as :NewArticle do
      it_should_behave_like AnArticle
      it { @result.should be_new_record }
    end

    describe "Model.new()" do
      before do
        @result = Article.new()
      end
      it_should_behave_like NewArticle
    end

    describe "Model.new({})" do
      before do
        @result = Article.new(@record_foo)
      end
      it_should_behave_like NewArticle
    end

  end

  describe "Create" do

    share_as :CreatedCollection do
      it { @result.first.should_not be_new_record }
      it_should_behave_like ACollection
    end

    share_as :CreatedArticle do
      it { @result.should_not be_new_record }
      it_should_behave_like AnArticle
    end

    describe "Model.create({})" do
      before { @result = Article.create(@record_foo) }
      it_should_behave_like CreatedArticle
    end

  end

end
