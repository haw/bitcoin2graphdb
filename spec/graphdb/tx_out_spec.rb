require 'spec_helper'

describe Graphdb::Model::TxOut do

  it 'create txout node' do
    hash = {
        'value' => 0.00350000, 'n' => 0,
        'scriptPubKey' => {
          'asm' => 'OP_HASH160 50f8a391e9234d8aadc340f00ab9404b231dd742 OP_EQUAL',
          'hex' => 'a91450f8a391e9234d8aadc340f00ab9404b231dd74287',
          'reqSigs' => 1,
          'type' => 'scripthash',
          'addresses' => ['2MzdMuNFP3gUpg4dZRFYc5KJhBPTa7mCsnm']
        }
    }
    tx_out = Graphdb::Model::TxOut.create_from_hash(hash)
    expect(tx_out.value).to eq(0.00350000)
    expect(tx_out.n).to eq(0)
    expect(tx_out.script_pubkey_asm).to eq('OP_HASH160 50f8a391e9234d8aadc340f00ab9404b231dd742 OP_EQUAL')
    expect(tx_out.script_pubkey_hex).to eq('a91450f8a391e9234d8aadc340f00ab9404b231dd74287')
    expect(tx_out.req_sigs).to eq(1)
    expect(tx_out.output_type).to eq('scripthash')
    expect(tx_out.addresses.length).to eq(1)
  end

end