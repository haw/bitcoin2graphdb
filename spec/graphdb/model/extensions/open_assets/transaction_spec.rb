require 'spec_helper'

describe 'Graphdb::Model::Extensions::OpenAssets::OaTransaction' do

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
      end
    end

    context 'issuance transaction' do
      subject{
        Graphdb::Model::Transaction.create_from_txid('fec95562b63e293d3cc45673be80a849a33eb121f244c74a5456515b28c62b1b')
      }
      it do
        expect(subject.outputs.length).to eq(3)
        expect(subject.outputs[0].asset_quantity).to eq(60000)
        expect(subject.outputs[0].asset_id.asset_id).to eq('oWHnxoBY9dxyGDC741vk84uniFmHoeo24T')
        expect(subject.outputs[0].oa_output_type).to eq('issuance')
        # marker output
        expect(subject.outputs[1].asset_quantity).to eq(0)
        expect(subject.outputs[1].asset_id).to be nil
        expect(subject.outputs[1].oa_output_type).to eq('marker')
        # change
        expect(subject.outputs[2].asset_quantity).to eq(0)
        expect(subject.outputs[2].asset_id).to be nil
        expect(subject.outputs[2].oa_output_type).to eq('uncolored')
      end
    end

    context 'send transaction' do
      subject{
        Graphdb::Model::Transaction.create_from_txid('b126aacedc27d12f1d3d653bd7430d7de6ad9ccb90ab116b3f0fd66175ffb556')
      }
      it do
        expect(subject.outputs.length).to eq(8)
        # marker output
        expect(subject.outputs[0].asset_quantity).to eq(0)
        expect(subject.outputs[0].asset_id).to be nil
        expect(subject.outputs[0].oa_output_type).to eq('marker')
        # colored output
        expect(subject.outputs[1].oa_output_type).to eq('transfer')
        expect(subject.outputs[1].asset_quantity).to eq(20000)
        expect(subject.outputs[1].asset_id.asset_id).to eq('oJkgThW1JdYe5K4ydMjVjrUKzux6vmNMry')
        expect(subject.outputs[2].oa_output_type).to eq('transfer')
        expect(subject.outputs[2].asset_quantity).to eq(20000)
        expect(subject.outputs[2].asset_id.asset_id).to eq('ocaizpC49ZCbtR9fFiQ7VwibJuyXRMomt3')
        expect(subject.outputs[3].oa_output_type).to eq('transfer')
        expect(subject.outputs[3].asset_quantity).to eq(60000)
        expect(subject.outputs[3].asset_id.asset_id).to eq('oWHnxoBY9dxyGDC741vk84uniFmHoeo24T')
        expect(subject.outputs[4].oa_output_type).to eq('transfer')
        expect(subject.outputs[4].asset_quantity).to eq(20000)
        expect(subject.outputs[4].asset_id.asset_id).to eq('oVxyUGXLJs7rcodDRetykZFY71WtgZKpFT')
        expect(subject.outputs[5].oa_output_type).to eq('transfer')
        expect(subject.outputs[5].asset_quantity).to eq(20000)
        expect(subject.outputs[5].asset_id.asset_id).to eq('oVxyUGXLJs7rcodDRetykZFY71WtgZKpFT')
        expect(subject.outputs[6].oa_output_type).to eq('transfer')
        expect(subject.outputs[6].asset_quantity).to eq(60000)
        expect(subject.outputs[6].asset_id.asset_id).to eq('oVxyUGXLJs7rcodDRetykZFY71WtgZKpFT')
        # change
        expect(subject.outputs[7].oa_output_type).to eq('uncolored')
        expect(subject.outputs[7].asset_quantity).to eq(0)
        expect(subject.outputs[7].asset_id).to be nil
      end
    end
  end

end