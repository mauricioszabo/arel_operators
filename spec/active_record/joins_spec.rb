require File.expand_path(File.dirname(__FILE__) + '/../helper')

describe ActiveRecord::Operators do
  it 'should obey joins' do
    p1 = Person.create! :name => 'Foo'
    p2 = Person.create! :name => 'Bar'
    p3 = Person.create! :name => 'Baz'
    Address.create! :address => "Road", :person_id => p3.id

    q1 = Person.where :name => 'Foo'
    q2 = Person.joins(:addresses).where('address = ?', 'Road')
    result = q1 | q2
    result.should include(p1)
    result.should include(p3)
    result.should_not include(p2)
  end
end
