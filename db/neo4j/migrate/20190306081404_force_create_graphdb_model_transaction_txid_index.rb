class ForceCreateGraphdbModelTransactionTxidIndex < Neo4j::Migrations::Base
  def up
    add_index :"Graphdb::Model::Transaction", :txid, force: true
  end

  def down
    drop_index :"Graphdb::Model::Transaction", :txid
  end
end
