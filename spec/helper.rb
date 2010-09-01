$LOAD_PATH << "./lib"
require "sqlite3"
require "active_record"
require "arel_operators"
ActiveRecord::Base.establish_connection(
  'adapter' => 'sqlite3',
  'database' => ':memory:'
)

ActiveRecord::Base.connection.execute("CREATE TABLE people(id integer primary key, name varchar(255))")
ActiveRecord::Base.connection.execute("CREATE TABLE addresses(id integer primary key, address varchar(255), person_id integer)")

class Person < ActiveRecord::Base
  extend ArelOperators
  has_many :addresses
end

class Address < ActiveRecord::Base
  extend ArelOperators
  belongs_to :person
end
