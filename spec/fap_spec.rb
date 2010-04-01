require File.dirname(__FILE__) + '/spec_helper.rb'

describe "a very light FAP" do
  before :all do
    class Foo < FAP::Paw ; end
  end
  
  it "should define #properties #accessor" do
    Foo.properties.should be_an_instance_of(Array)
    Foo.properties.should be_empty
  end

  it "should define #relations read accessor" do
    Foo.relations.should be_an_instance_of(Array)
    Foo.relations.should be_empty
  end
end

describe "a very light FAP with properties" do
  before :all do
    class Foo < FAP::Paw
      property :str_name
      property :str_prop, 'String'
      property :xpath_prop, 'Fixnum', :xpath => '//foobar'
    end
  end

  it "should have 3 properties" do
    Foo.properties.should have(3).items
  end

  it "should have 2 'String' properties" do
    props = Foo.properties.select { |prop| prop.name != :xpath_prop }
    props.each do |prop|
      prop.type.should == 'String'
    end
  end

  it "should have 1 'Fixnum' property" do
    props = Foo.properties.select { |prop| prop.name == :xpath_prop }
    props.each do |prop|
      prop.type.should == 'Fixnum'
    end
  end

  it "should define a property's xpath with the :xpath option" do
    props = Foo.properties.select { |prop| prop.name == :xpath_prop }
    props.each do |prop|
      prop.xpath.should == '//foobar'
    end
  end

  it "should define property accessors" do
    x = Foo.new nil
    x.should respond_to(:str_name)
    x.should respond_to(:str_prop)
    x.should respond_to(:xpath_prop)
  end
end

describe "a FAP with some relations" do
  before :all do
    class Foo < FAP::Paw
      has_many :bars, :class => 'Bar', :xpath => '//foo/bars'
    end

    class Bar < FAP::Paw
      belongs_to :foo, :class => 'Foo'
    end
  end

  it "should define some relations" do
    Foo.relations.should have(1).item
    Bar.relations.should have(1).item
  end

  it "should define has_many relations" do
    x = Foo.new nil
    x.should respond_to(:bars)
    x.bars.should be_an_instance_of(FAP::Collection)
  end

  it "should define belongs_to relations" do
    x = Bar.new nil
    x.should respond_to(:foo)
    x.foo.should be_an_instance_of(NilClass)
  end
end

describe "a simple FAP to read a stream" do
  before :all do
    class Foo < FAP::Paw ; end
  end

  it "should load a File object" do
    foo = Foo.new open('spec/fixtures/twitter-search.atom')
  end
end

describe "a simple FAP to parse an atom feed" do
  before :all do
    # Define a simple Atom parser for twitter searches.
    class Atom < FAP::Paw
      string :title,   :xpath => '//feed/title'
      uri    :url,     :xpath => '//feed/link[@rel="self"]', :get => :href
      date   :updated, :xpath => '//feed/updated'

      has_many :articles, :class => 'Article', :xpath => '//feed/entry'
    end

    class Article < FAP::Paw
      string :title
      uri    :url, :xpath => 'link[@rel="alternate"]', :get => :href
      string :content
      date   :updated_at, :xpath => 'updated'

      belongs_to :atom, :class => 'Atom'
    end
  end

  before :each do
    @atom = Atom.new open('spec/fixtures/twitter-search.atom')
  end

  it "should find a title" do
    @atom.title.should == "ruby - Twitter Search"
  end

  it "should find a URI" do
    @atom.url.should be_an_instance_of(URI::HTTP)
  end

  it "should find a date" do
    @atom.updated.should be_an_instance_of(DateTime)
  end

  it "should define a collection of :articles" do
    @atom.articles.should be_an_instance_of(FAP::Collection)
    @atom.articles.should respond_to(:each)
  end

  it "should map relations to their required class" do
    @atom.articles.first.should be_an_instance_of(Article)
  end

  it "should map relations to their required class instances" do
    @atom.articles.first.title.should be_an_instance_of(String)
    @atom.articles.first.url.should be_an_instance_of(URI::HTTP)
    @atom.articles.first.content.should be_an_instance_of(String)
    @atom.articles.first.updated_at.should be_an_instance_of(DateTime)
    @atom.articles.first.atom.should be_an_instance_of(Atom)
  end

  it "should preserve relations' objects" do
    @atom.articles.first.atom.object_id.should == @atom.object_id
  end
end
