require "sqlite3"
require "active_record"
require "ar_operators"
ActiveRecord::Base.establish_connection(
  'adapter' => 'sqlite3',
  'database' => ':memory:'
)

ActiveRecord::Base.connection.execute("CREATE TABLE people(id integer, name varchar(255))")

class Person < ActiveRecord::Base
  extend AROperators
end
