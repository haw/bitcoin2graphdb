require 'spec_helper'

describe 'Graphdb::Model::Extensions::OpenAssets::OaTransaction' do

  before{
    Graphdb::Model::Transaction.prepend(Graphdb::Model::Extensions::OpenAssets::OaTransaction)
  }

  describe 'create oa transaction' do
    context 'not oa transaction' do
      subject{
        Graphdb::Model::Transaction.create_from_txid('f0315ffc38709d70ad5647e22048358dd3745f3ce3874223c80a7c92fab0c8ba')
      }
      it do
        expect(subject.output_type).to eq('uncolored')
      end
    end

    context 'issuance transaction' do
      subject{
        Graphdb::Model::Transaction.create_from_txid('fec95562b63e293d3cc45673be80a849a33eb121f244c74a5456515b28c62b1b')
      }
      it do
        expect(subject.output_type).to eq('issuance')
      end
    end

    context 'send transaction' do
      subject{
        Graphdb::Model::Transaction.create_from_txid('b126aacedc27d12f1d3d653bd7430d7de6ad9ccb90ab116b3f0fd66175ffb556')
      }
      it do
        expect(subject.output_type).to eq('transfer')
      end
    end
  end

end