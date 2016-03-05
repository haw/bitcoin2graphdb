module Graphdb
  module Model
    # The base class of Neo4j ActiveNode
    class ActiveNodeBase
      include Neo4j::ActiveNode

      property :created_at
      property :updated_at

      def self.remove_module(m)
        m.instance_methods.each{|m| undef_method(m)}
      end
    end
  end
end