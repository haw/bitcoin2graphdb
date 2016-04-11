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
    get_migration(args.config_path).run_with_height(args.block_height.to_i)
  end

  desc 'Remove specified block from neo4j database.'
  task :remove_block, [:block_height,:config_path] do |task, args|
    puts "remove #{args.block_height} block."
    get_migration(args.config_path).remove_block(args.block_height.to_i)
  end

  desc 'Import specified transaction to neo4j database.'
  task :import_tx, [:txid,:config_path] do |task, args|
    get_migration(args.config_path).import_tx(args.txid)
  end

  desc 'Remove specified transaction from neo4j database.'
  task :remove_tx, [:txid,:config_path] do |task, args|
    get_migration(args.config_path).remove_tx(args.txid)
  end

  desc 'Repair specified transaction.'
  task :repair_tx, [:txid,:config_path] do |task, args|
    get_migration(args.config_path).remove_tx(args.txid)
    get_migration(args.config_path).import_tx(args.txid)
  end

  private
  def get_migration(config_path)
    config = YAML.load(File.read(config_path)).deep_symbolize_keys[:bitcoin2graphdb]
    Bitcoin2Graphdb::Migration.new(config)
  end
end