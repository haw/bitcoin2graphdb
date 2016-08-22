require 'base'

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

  desc 'Remove down to block specified from the latest block'
  task :remove_until_block, [:block_height,:config_path] do |task, args|
    target_block_height = args.block_height.to_i
    puts "remove_until_block down to #{target_block_height}"
    migration = get_migration(args.config_path)
    current_height = Graphdb::Model::Block.latest.first.height
    current_height.downto(target_block_height) do |height|
      migration.remove_block(height)
    end
  end

  desc 'Search invalid oa tx.(invalid tx exist only openassets-ruby bug.)'
  task :search_invalid_oa_tx, [:config_path] do |task, args|
    get_migration(args.config_path).search_invalid_oa_tx
  end

  private
  def get_migration(config_path)
    config = YAML.load(File.read(config_path)).deep_symbolize_keys[:bitcoin2graphdb]
    Bitcoin2Graphdb::Migration.new(config)
  end
end