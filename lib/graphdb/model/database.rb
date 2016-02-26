module  Graphdb
  module Model
    class Database

      attr_reader :neo

      def initialize(config)
        @neo = Neo4j::Session.open(:server_db)
      end

      # Create block node
      def create_block_node(block)
        block['type'] = 'block'
        neo.create_node(block)
      end

      # Create tx node
      def create_tx_node(block, tx)
        hash = {
            'type': 'transaction', 'blockhash': block['hash'], 'hash': tx.hash, 'hex': tx.to_payload.bth,
            'version': tx.ver, 'locktime': tx.lock_time, 'blocktime': block['time']
        }
        neo.create_node(hash)
      end

      # Create tx-in node
      def create_tx_in_node(txin)
        hash = create_tx_in_hash(txin)

        neo.create_node(hash)
      end

      # Create tx-out node
      def create_tx_out_node(txout)
        tx_hash = txout.to_hash
        hash = {}
        puts hash
      end

      private
      def create_tx_in_hash(txin)
        tx_hash = txin.to_hash
        if txin.coinbase?
          hash = {'coinbase': tx_hash['coinbase'], 'sequence': tx_hash['sequence']}
        else
          hash = {'txid': tx_hash['prev_out']['hash'], 'vout': tx_hash['prev_out']['n'], 'script_sig': tx_hash['script_sig'], 'sequence': tx_hash['sequence']}
        end
        hash['type'] = 'input'
        hash
      end

    end
  end
end