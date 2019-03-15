class ForceCreateGraphdbModelAssetIdAssetIdIndex < Neo4j::Migrations::Base
  def up
    add_index :"Graphdb::Model::AssetId", :asset_id, force: true
  end

  def down
    drop_index :"Graphdb::Model::AssetId", :asset_id
  end
end
