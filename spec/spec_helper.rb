require 'bundler'
Bundler.require :default, :development

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'factories'
require 'enum_type'

ActiveRecord::Base.establish_connection(
  adapter: (defined?(JRuby) ? 'jdbcpostgresql' : 'postgresql'),
  database: 'enum_type_test',
  username: 'enum_type_tester',
  host: 'localhost'
)

class Model < ActiveRecord::Base
  extend EnumType
  enum_type :state, allow_nil: true, values: %w( pending processing completed failed )
end

RSpec.configure do |config|
  config.before(:each) do
    Model.connection.execute "DROP TABLE IF EXISTS models"
    Model.connection.execute "DROP TYPE IF EXISTS state_type"
    Model.connection.execute "CREATE TYPE state_type AS ENUM ('pending', 'processing', 'completed', 'failed')"
    Model.connection.execute "CREATE TABLE models (id SERIAL PRIMARY KEY, state state_type DEFAULT 'pending')"
    Model.connection.reconnect!
  end
end
