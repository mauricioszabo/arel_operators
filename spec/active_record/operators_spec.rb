require File.expand_path(File.dirname(__FILE__) + '/../helper')
require "ruby_debug"

describe ActiveRecord::Operators do
  it 'Should add two conditions' do
    arel = Person.where(:id => 190) + Person.where(:id => 210)
    result = arel.to_sql
    puts result
    result.should match(/or/i)
    result.should match(/210/i)
    result.should match(/190/i)
  end

  it 'should negate the condition' do
    arel = -Person.where(:id => 190)
    result = arel.to_sql
    puts result
    result.should match(/not/i)
    result.should match(/190/i)
  end

  it 'Should subtract two conditions' do
    arel = Person.where(:id => 190) - Person.where(:id => 210)
    result = arel.to_sql
    puts result
    result.should match(/and.*not/i)
    result.should match(/210/i)
    result.should match(/190/i)
  end
end
