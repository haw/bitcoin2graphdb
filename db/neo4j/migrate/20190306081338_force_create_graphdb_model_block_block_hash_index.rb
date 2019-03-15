class ForceCreateGraphdbModelBlockBlockHashIndex < Neo4j::Migrations::Base
  def up
    add_index :"Graphdb::Model::Block", :block_hash, force: true
  end

  def down
    drop_index :"Graphdb::Model::Block", :block_hash
  end
end
