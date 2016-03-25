require 'spec_helper'
describe Graphdb do

  describe 'configuration' do

    context 'default configuration' do
      subject{
        Graphdb::Configuration.new
      }
      it do
        expect(subject.extensions.empty?).to be true
        expect(subject.neo4j_server).to eq('http://localhost:7474')
      end
    end

    context 'specify configuration' do
      before {
        Graphdb.configure do |config|
          config.neo4j_server = 'http://localhost:7475'
          config.extensions = ['open_assets']
        end
      }
      subject{
        Graphdb.configuration
      }
      it do
        expect(subject.extensions.length).to eq(1)
        expect(subject.extensions[0]).to eq('open_assets')
        expect(subject.neo4j_server).to eq('http://localhost:7475')
      end
    end
  end

end