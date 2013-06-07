require_relative "../helper"

describe ArelOperators::Finder do
  before do
    @table = Person.arel_table
    @finder = ArelOperators::Finder.new Person.arel_table
  end

  it 'should return a empty arel if not being able to convert' do
    @finder.arel.should be_nil
  end

  it 'should not calculate equality' do
    proc { @finder == @finder }.should raise_error(NoMethodError)
    proc { @finder != @finder }.should raise_error(NoMethodError)
  end

  it 'should be able to expose the class attributes' do
    @finder.name.should be_a_kind_of(ArelOperators::Finder::Comparators)
    @finder.id.should be_a_kind_of(ArelOperators::Finder::Comparators)
  end

  it 'should be able to "or" two conditions' do
    c1 = @table[:id].eq(1)
    c2 = @table[:name].eq(2)
    ((@finder.id == 1) | (@finder.name == 2)).arel.should be_equivalent_to(c1.or(c2))
  end

  it 'should be able to "and" two conditions' do
    c1 = @table[:id].eq(1)
    c2 = @table[:name].eq(2)
    ((@finder.id == 1) & (@finder.name == 2)).arel.should be_equivalent_to c1.and(c2)
  end

  it 'should be able to negate the find (in Ruby1.9)' do
    next if RUBY_VERSION < '1.9.0'
    @finder = ArelOperators::Finder.new Person.arel_table, @table[:name].eq('foo')
    (!@finder).arel.should be_equivalent_to Arel::Nodes::Not.new(@table[:name].eq('foo'))
  end

  it 'should be able to negate the find with -@' do
    @finder = ArelOperators::Finder.new Person.arel_table, @table[:name].eq('foo')
    (-@finder).arel.should be_equivalent_to Arel::Nodes::Not.new(@table[:name].eq('foo'))
  end

  #it 'should be able to find in a subselect'

  context 'when finding using WHERE and a block' do
    before do
      @p1 = Person.create! :name => 'Foo', :age => 17
      @p2 = Person.create! :name => 'Foo', :age => 18
    end

    after do
      Person.delete_all
    end

    it 'should be able to find using a block with one parameter' do
      result = Person.where { |p| (p.name == 'Foo') & (p.age > 17) }
      result.should == [@p2]
    end

    it 'should be able to find using a block with no parameters' do
      result = Person.where { (name == 'Foo') & (age > 17) }
      result.should == [@p2]
    end

    it 'should be able to find using a condition too' do
      result = Person.where(:age => 17) { name == 'Foo' }
      result.should == [@p1]
    end

    it 'should be able to find on a HAVING condition' do
      pending
    end
  end
end
