require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'base'
require 'neo4j/rake_tasks'
load 'bitcoin2graphdb/tasks/migration.rake'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
