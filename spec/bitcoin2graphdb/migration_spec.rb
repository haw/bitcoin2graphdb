require 'spec_helper'

describe Bitcoin2Graphdb::Migration, migration: true do

  describe 'load configuration' do
    context 'default configuration' do
      subject{
        config = YAML.load(File.read("#{File.dirname(__FILE__)}/../fixtures/default-config.yml")).deep_symbolize_keys
        Bitcoin2Graphdb::Migration.new(config[:bitcoin2graphdb])
        Graphdb.configuration
      }
      it do
        expect(subject.neo4j_server).to eq('http://localhost:7475')
        expect(subject.extensions).to be_empty
      end
    end

    context 'open assets configuration' do
      subject{
        config = YAML.load(File.read("#{File.dirname(__FILE__)}/../fixtures/open_assets-config.yml")).deep_symbolize_keys
        Bitcoin2Graphdb::Migration.new(config[:bitcoin2graphdb])
        change_neo4j_adaptor(config[:bitcoin2graphdb])
        Graphdb.configuration
      }

      let(:options){ Neo4j::ActiveBase.current_session.adaptor.requestor.instance_variable_get("@faraday").options }

      it do
        expect(subject.extensions.length).to eq(1)
        expect(subject.extensions[0]).to eq('open_assets')
      end

      it do
        expect(subject.neo4j_server).to eq('http://localhost:7475')
        expect(options.timeout).to eq(6000)
        expect(options.open_timeout).to eq(5)
      end
    end

    context 'bolt configuration' do
      subject{
        config = YAML.load(File.read("#{File.dirname(__FILE__)}/../fixtures/bolt-config.yml")).deep_symbolize_keys
        Bitcoin2Graphdb::Migration.new(config[:bitcoin2graphdb])
        change_neo4j_adaptor(config[:bitcoin2graphdb])
        Graphdb.configuration
      }

      let(:options){ Neo4j::ActiveBase.current_session.adaptor.instance_variable_get("@net_tcp_client_options") }

      it do
        expect(subject.neo4j_server).to eq('bolt://localhost:7473')
        expect(options[:read_timeout]).to eq(-1)
        expect(options[:write_timeout]).to eq(-1)
        expect(options[:connect_timeout]).to eq(10)
        expect(options[:ssl]).to be_falsey
      end
    end

    context 'specify timeout settings' do
      it do
        config = YAML.load(File.read("#{File.dirname(__FILE__)}/../fixtures/default-config.yml")).deep_symbolize_keys
        migration = Bitcoin2Graphdb::Migration.new(config[:bitcoin2graphdb])
        ops = migration.send(:neo4j_timeout_ops, config[:bitcoin2graphdb])
        expect(ops[:request][:timeout]).to eq(600)
        expect(ops[:request][:open_timeout]).to eq(2)
      end

      it do
        config = YAML.load(File.read("#{File.dirname(__FILE__)}/../fixtures/open_assets-config.yml")).deep_symbolize_keys
        migration = Bitcoin2Graphdb::Migration.new(config[:bitcoin2graphdb])
        ops = migration.send(:neo4j_timeout_ops, config[:bitcoin2graphdb])
        expect(ops[:request][:timeout]).to eq(6000)
        expect(ops[:request][:open_timeout]).to eq(5)
      end
    end
  end

end