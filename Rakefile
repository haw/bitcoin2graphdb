require "bundler/gem_tasks"
require "rspec/core/rake_task"
load 'neo4j/tasks/neo4j_server.rake'
load 'neo4j/tasks/migration.rake'
require 'base'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :b2g do
  desc 'Import specified block to neo4j database.'
  task :import_block, [:block_height,:config_path] do |task, args|
    puts "import #{args.block_height} block."
    Bitcoin2Graphdb::Migration.new(load_config(args.config_path)).run_with_height(args.block_height.to_i)
  end

  task :remove_block, [:block_height,:config_path] do |task, args|
    config = load_config(args.config_path)
    Neo4j::Session.open(:server_db, config[:neo4j][:server], {basic_auth: config[:neo4j][:basic_auth]})
    block = Graphdb::Model::Block.with_height(args.block_height.to_i).first
    if block.nil?
      puts "block height #{args.block_height} does not exist."
    else
      block.destroy
      puts "block height #{args.block_height} is deleted."
    end
  end

  def load_config(config_path)
    YAML.load(File.read(config_path)).deep_symbolize_keys[:bitcoin2graphdb]
  end
end