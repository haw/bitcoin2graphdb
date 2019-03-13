class ForceCreateGraphdbModelActiveNodeBaseUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :"Graphdb::Model::ActiveNodeBase", :uuid, force: true
  end

  def down
    drop_constraint :"Graphdb::Model::ActiveNodeBase", :uuid
  end
end
