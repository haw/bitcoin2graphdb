class ForceCreateGraphdbModelAddressAddressIndex < Neo4j::Migrations::Base
  def up
    add_index :"Graphdb::Model::Address", :address, force: true
  end

  def down
    drop_index :"Graphdb::Model::Address", :address
  end
end
