require File.expand_path(File.dirname(__FILE__) + '/../helper')
require "ruby_debug"

describe ActiveRecord::Operators do
  it 'Should "or" two conditions' do
    arel = Person.where(:id => 190) | Person.where(:id => 210)
    result = arel.to_sql
    result.should match(/or/i)
    result.should match(/210/i)
    result.should match(/190/i)
  end

  it 'Should "and" two conditions' do
    arel = Person.where(:id => 190) & Person.where(:id => 210)
    result = arel.to_sql
    result.should match(/and/i)
    result.should match(/210/i)
    result.should match(/190/i)
  end

  it 'should negate the condition' do
    arel = -Person.where(:id => 190)
    result = arel.to_sql
    result.should match(/not/i)
    result.should match(/190/i)
  end

  it 'should subtract two conditions' do
    arel = Person.where(:id => 190) - Person.where(:id => 210)
    result = arel.to_sql
    result.should match(/and.*not/i)
    result.should match(/210/i)
    result.should match(/190/i)
  end

  it 'should create subselects' do
    foo = Person.create! :name => 'Foo'
    bar = Person.create! :name => 'Bar'
    baz = Person.create! :name => 'Baz'
    select = Person.where :name => ['Foo', 'Baz']
    subselect = Person.where :name => ['Baz', 'Bar']
    result = select.where(subselect)
    result.should include(baz)
    result.should_not include(foo)
    result.should_not include(bar)
    sql = result.to_sql
    sql.scan(/select/i).should have(2).matches
  end
end
