require 'spec_helper'

describe "Model.find_by_foo" do

  before do
    @article = Article.create(:title => "FooBar",
                              :text  => "Original text")
  end

  it 'should find one' do
    article = Article.find_by_title("FooBar")

    article.text.should == "Original text"
  end

end


