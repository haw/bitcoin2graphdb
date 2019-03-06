require 'rubygems'
require 'base'
require 'bitcoin_mock'
require 'neo4j/core/cypher_session/adaptors/http'

RSpec.configure do |config|

  include BitcoinMock

  config.before(:each) do |example|
    neo4j_session
    unless example.metadata[:cli]
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
      Neo4j::ActiveBase.current_session.query('MATCH(n) DETACH DELETE n')
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

def neo4j_session
  neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.new('http://localhost:7475', { :basic_auth => { username: 'neo4j', password: 'neo4j' }, :initialize => { :request => {:timeout => 600, :open_timeout => 2}}})
  Neo4j::ActiveBase.on_establish_session { Neo4j::Core::CypherSession.new(neo4j_adaptor) }
end