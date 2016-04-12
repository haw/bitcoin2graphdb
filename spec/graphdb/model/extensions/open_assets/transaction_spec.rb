require 'spec_helper'

describe 'Graphdb::Model::Extensions::OpenAssets::Transaction' do

  before{
    Graphdb::Model::Transaction.prepend(Graphdb::Model::Extensions::OpenAssets::Transaction)
    Graphdb::Model::TxOut.prepend(Graphdb::Model::Extensions::OpenAssets::TxOut)
  }

  describe 'create oa transaction' do
    context 'not oa transaction' do
      subject{
        Graphdb::Model::Transaction.create_from_txid('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
      }
      it do
        expect(subject.outputs.length).to eq(1)
        expect(subject.outputs[0].asset_quantity).to eq(0)
        expect(subject.outputs[0].asset_id).to be nil
        expect(subject.outputs[0].oa_output_type).to eq('uncolored')
        expect(subject.openassets_tx?).to be false
      end
    end

    context 'issuance transaction' do
      txid = 'fec95562b63e293d3cc45673be80a849a33eb121f244c74a5456515b28c62b1b'
      subject{
        Graphdb::Model::Transaction.create_from_txid(txid)
      }
      it do
        expect(subject.outputs.length).to eq(3)
        o0 = Graphdb::Model::TxOut.find_by_outpoint(txid, 0)
        expect(o0.asset_quantity).to eq(60000)
        expect(o0.asset_id.asset_id).to eq('oWHnxoBY9dxyGDC741vk84uniFmHoeo24T')
        expect(o0.oa_output_type).to eq('issuance')
        # marker output
        o1 = Graphdb::Model::TxOut.find_by_outpoint(txid, 1)
        expect(o1.asset_quantity).to eq(0)
        expect(o1.asset_id).to be nil
        expect(o1.oa_output_type).to eq('marker')
        # change
        o2 = Graphdb::Model::TxOut.find_by_outpoint(txid, 2)
        expect(o2.asset_quantity).to eq(0)
        expect(o2.asset_id).to be nil
        expect(o2.oa_output_type).to eq('uncolored')

        expect(subject.openassets_tx?).to be true
      end
    end

    context 'send transaction' do
      txid = 'b126aacedc27d12f1d3d653bd7430d7de6ad9ccb90ab116b3f0fd66175ffb556'
      subject{
        Graphdb::Model::Transaction.create_from_txid(txid)
      }
      it do
        expect(subject.outputs.length).to eq(8)
        # marker output
        o0 = Graphdb::Model::TxOut.find_by_outpoint(txid, 0)
        expect(o0.asset_quantity).to eq(0)
        expect(o0.asset_id).to be nil
        expect(o0.oa_output_type).to eq('marker')
        # colored output
        o1 = Graphdb::Model::TxOut.find_by_outpoint(txid, 1)
        expect(o1.oa_output_type).to eq('transfer')
        expect(o1.asset_quantity).to eq(20000)
        expect(o1.asset_id.asset_id).to eq('oJkgThW1JdYe5K4ydMjVjrUKzux6vmNMry')
        o2 = Graphdb::Model::TxOut.find_by_outpoint(txid, 2)
        expect(o2.oa_output_type).to eq('transfer')
        expect(o2.asset_quantity).to eq(20000)
        expect(o2.asset_id.asset_id).to eq('ocaizpC49ZCbtR9fFiQ7VwibJuyXRMomt3')
        o3 = Graphdb::Model::TxOut.find_by_outpoint(txid, 3)
        expect(o3.oa_output_type).to eq('transfer')
        expect(o3.asset_quantity).to eq(60000)
        expect(o3.asset_id.asset_id).to eq('oWHnxoBY9dxyGDC741vk84uniFmHoeo24T')
        o4 = Graphdb::Model::TxOut.find_by_outpoint(txid, 4)
        expect(o4.oa_output_type).to eq('transfer')
        expect(o4.asset_quantity).to eq(20000)
        expect(o4.asset_id.asset_id).to eq('oVxyUGXLJs7rcodDRetykZFY71WtgZKpFT')
        o5 = Graphdb::Model::TxOut.find_by_outpoint(txid, 5)
        expect(o5.oa_output_type).to eq('transfer')
        expect(o5.asset_quantity).to eq(20000)
        expect(o5.asset_id.asset_id).to eq('oVxyUGXLJs7rcodDRetykZFY71WtgZKpFT')
        o6 = Graphdb::Model::TxOut.find_by_outpoint(txid, 6)
        expect(o6.oa_output_type).to eq('transfer')
        expect(o6.asset_quantity).to eq(60000)
        expect(o6.asset_id.asset_id).to eq('oVxyUGXLJs7rcodDRetykZFY71WtgZKpFT')
        # change
        o7 = Graphdb::Model::TxOut.find_by_outpoint(txid, 7)
        expect(o7.oa_output_type).to eq('uncolored')
        expect(o7.asset_quantity).to eq(0)
        expect(o7.asset_id).to be nil

        expect(subject.openassets_tx?).to be true
      end
    end
  end

end