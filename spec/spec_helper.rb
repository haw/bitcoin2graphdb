require 'rubygems'
require 'base'
require 'bitcoin_mock'
require 'neo4j/core/cypher_session/adaptors/http'
require 'neo4j/core/cypher_session/adaptors/bolt'

RSpec.configure do |config|

  include BitcoinMock

  config.before(:each) do |example|
    neo4j_session
    unless example.metadata[:cli]
      setup_mock
      unless example.metadata[:migration]
        Graphdb.configure do |config|
          config.neo4j_server = 'http://localhost:7475'
          config.extensions = ['open_assets']
        end
      end
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
  neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new('bolt://localhost:7473', { ssl: false })
  Neo4j::ActiveBase.on_establish_session { Neo4j::Core::CypherSession.new(neo4j_adaptor) }
end

def change_neo4j_adaptor(config = nil)
  if config
    uri = URI(config[:neo4j][:server])
    case uri.scheme
    when 'http'
      faraday_configurator = proc do |faraday|
        require 'typhoeus'
        require 'typhoeus/adapters/faraday'
        faraday.adapter :typhoeus
        faraday.options.merge!(config[:neo4j][:initialize][:request])
      end
      neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.new('http://localhost:7475', faraday_configurator: faraday_configurator)
    when 'bolt'
      neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new('bolt://localhost:7473', config[:neo4j][:options])
    else
      fail ArgumentError, "Invalid URL: #{uri.inspect}"
    end
    graphdb_configure(config)
  else
    neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new('bolt://localhost:7473', { ssl: false })
  end
  Neo4j::ActiveBase.current_adaptor = neo4j_adaptor
end

def graphdb_configure(config)
  uri = URI(config[:neo4j][:server])
  case uri.scheme
  when 'http'
    Graphdb.configure do |conf|
      conf.neo4j_server = 'http://localhost:7475'
      conf.extensions = config[:extensions]
    end
  when 'bolt'
    Graphdb.configure do |conf|
      conf.neo4j_server = 'bolt://localhost:7473'
      conf.extensions = config[:extensions]
    end
  end
end