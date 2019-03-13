require 'rubygems'
require 'base'
require 'database_cleaner'
require 'bitcoin_mock'
require 'neo4j'

Dir[File.join(File.dirname(__FILE__ ), 'mocks', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|

  DatabaseCleaner[:neo4j, connection: {type: :server_db, path: 'http://localhost:7475'}].strategy = :transaction
  include BitcoinMock

  config.before(:each) do |example|
    unless example.metadata[:cli]
      DatabaseCleaner.start
      setup_mock
      Graphdb.configuration.unload_extensions
    end
  end

  config.after(:each) do |example|
    if example.metadata[:cli]
      Dir.glob(["*.pid", "*.log"]).each do |f|
        File.delete f
      end
    else
      DatabaseCleaner.clean
    end
  end

  # for thor command.
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end

end

def fixture_file(relative_path)
  file = File.read(File.join(File.dirname(__FILE__), 'fixtures', relative_path))
  JSON.parse(file)
end
