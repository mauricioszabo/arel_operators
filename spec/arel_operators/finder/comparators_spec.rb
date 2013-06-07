require_relative "../../helper"

describe ArelOperators::Finder::Comparators do
  before do
    @table = Person.arel_table
    @finder = ArelOperators::Finder.new Person.arel_table
    @comparator = ArelOperators::Finder::Comparators.new @finder, @finder.table[:name]
  end

  it 'should be able to find by equality' do
    (@comparator == 'foo').should be_a_kind_of(ArelOperators::Finder)
    (@comparator == 'foo').arel.should be_equivalent_to(@table[:name].eq('foo'))
  end

  it 'should be able to find by inequality (Ruby1.9 only)' do
    next if RUBY_VERSION < '1.9.0'
    (@comparator != 'foo').arel.should be_equivalent_to(@table[:name].not_eq('foo'))
  end

  it 'should be able to verify if an attribute is nil' do
    (@comparator.nil?).arel.should be_equivalent_to(@table[:name].eq(nil))
  end

  it 'should be able to find by greater than' do
    (@comparator > 'foo').arel.should be_equivalent_to @table[:name].gt('foo')
    (@comparator >= 'foo').arel.should be_equivalent_to @table[:name].gteq('foo')
  end

  it 'should be able to find by lower than' do
    (@comparator < 'foo').arel.should be_equivalent_to @table[:name].lt('foo')
    (@comparator <= 'foo').arel.should be_equivalent_to @table[:name].lteq('foo')
  end

  it 'should be able to find IN' do
    @comparator.in?(['foo']).arel.should be_equivalent_to @table[:name].in(['foo'])
  end

  it 'should be able to find with LIKE' do
    @comparator.like?('foo').arel.should be_equivalent_to @table[:name].matches('foo')
    @comparator.matches?('foo').arel.should be_equivalent_to @table[:name].matches('foo')
    (@comparator =~ 'foo').arel.should be_equivalent_to @table[:name].matches('foo')
  end

  #it 'should be able to find with Regex'
end
