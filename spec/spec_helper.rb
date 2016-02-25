require 'rubygems'
require 'bitcoin2graphdb'
require 'database_cleaner'
require 'bitcoin_mock'
require 'neo4j'

RSpec.configure do |config|
  # DatabaseCleaner[:graphdb, connection: {type: :server_db, path: 'http://localhost:7475'}].strategy = :transaction
  include BitcoinMock

  config.before(:each) do
    # DatabaseCleaner.start
    setup_mock
  end

  config.after(:each) do
    # DatabaseCleaner.clean
  end

end