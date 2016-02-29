module Graphdb
  module Model
    # The base class of Neo4j ActiveNode
    class ActiveNodeBase
      include Neo4j::ActiveNode

      property :created_at
      property :updated_at

    end
  end
end