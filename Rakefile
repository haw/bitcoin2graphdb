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
    config = YAML.load(File.read(args.config_path)).deep_symbolize_keys
    puts "import #{args.block_height} block."
    Bitcoin2Graphdb::Migration.new(config[:bitcoin2graphdb]).run_with_height(args.block_height.to_i)
  end
end