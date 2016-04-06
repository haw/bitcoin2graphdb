require 'spec_helper'

describe Graphdb::Model::Address do

  describe 'get transactions' do
    before{
      Graphdb::Model::Transaction.create_from_txid('b126aacedc27d12f1d3d653bd7430d7de6ad9ccb90ab116b3f0fd66175ffb556')
      Graphdb::Model::Transaction.create_from_txid('fec95562b63e293d3cc45673be80a849a33eb121f244c74a5456515b28c62b1b')
    }
    subject{
      Graphdb::Model::Address.with_address('mhFpfzXx6KXJxqmZha7bQo6g1C5LjdFpc5').first
    }
    it do
      subject.outputs.each do |o|
        expect(o.script_pubkey_hex).to eq('76a9141313a65b1ec5e9a6907819c536c644dc7a8e034188ac')
      end
    end
  end

end