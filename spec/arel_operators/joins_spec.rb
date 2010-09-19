require File.expand_path(File.dirname(__FILE__) + '/../helper')

describe ArelOperators::Operators do
  before do
    @p1 = Person.create! :name => 'Foo'
    @p2 = Person.create! :name => 'Bar'
    @p3 = Person.create! :name => 'Baz'
    Address.create! :address => "Avenue", :person_id => @p2.id
    Address.create! :address => "Road", :person_id => @p3.id
  end

  after do
    Person.delete_all; Address.delete_all
  end

  it 'should obey joins' do
    Address.create! :address => "Village", :person_id => @p1.id
    q1 = Person.where :name => 'Foo'
    q2 = Person.joins(:addresses).where('addresses.address = ?', 'Road')
    result = q2 | q1
    result.to_sql.should match(/inner join/i)
    result.should include(@p1)
    result.should include(@p3)
    result.should_not include(@p2)
  end

  it 'should obey left joins' do
    pending 'Left Join in Rails?'
    q1 = Person.where :name => 'Foo'
    q2 = Person.eager_load(:addresses).where('addresses.address = ?', 'Road')
    puts q2.to_sql
    result = q1 | q2
    result.to_sql.should match(/join/i)
    result.should include(@p1)
    result.should include(@p3)
    result.should_not include(@p2)
  end
end
