require 'spec_helper'

describe Graphdb::Model::Extensions do

  describe 'available extensions' do
    it do
      expect(Graphdb::Model::Extensions::EXTENSIONS.length).to eq(1)
      expect(Graphdb::Model::Extensions::EXTENSIONS[:open_assets]).to eq('graphdb/model/extensions/open_assets')
    end
  end

  describe 'load extensions' do

    context 'load open assets extension' do
      before{
        Graphdb::Model::Transaction.prepend(Graphdb::Model::Extensions::OpenAssets::OaTransaction)
      }
      subject{
        Graphdb::Model::Transaction.new
      }
      it do
        subject.output_type = 'issuance'
        expect(subject.output_type).to eq('issuance')
      end
    end

    context 'does not load extensions' do
      before{
        Graphdb::Model.send(:remove_const, :Transaction)
        load 'graphdb/model/transaction.rb'
        Graphdb.configure do |gconfig|
          gconfig.extensions = []
        end
      }
      subject{
        Graphdb::Model::Transaction.new
      }
      it do
        expect{subject.output_type = 'issuance'}.to raise_error NoMethodError
      end
    end
  end

end