$LOAD_PATH << "./lib"
require "sqlite3"
require "active_record"
require "arel_operators"
ActiveRecord::Base.establish_connection(
  'adapter' => 'sqlite3',
  'database' => ':memory:'
)

ActiveRecord::Base.connection.execute("CREATE TABLE people(id integer primary key, name varchar(255))")

class Person < ActiveRecord::Base
  extend ArelOperators
end
