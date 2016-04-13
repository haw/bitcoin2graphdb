require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'base'
load 'neo4j/tasks/neo4j_server.rake'
load 'neo4j/tasks/migration.rake'
load 'bitcoin2graphdb/tasks/migration.rake'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
