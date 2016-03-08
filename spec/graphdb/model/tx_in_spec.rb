require 'spec_helper'

describe Graphdb::Model::TxIn do

  describe 'create txin node' do
    context 'coinbase' do
      subject {
        hash1 = {'coinbase' => '0420e7494d017f062f503253482f','sequence' => 4294967295}
        Graphdb::Model::TxIn.create_from_hash(hash1)
      }
      it do
        expect(subject.coinbase).to eq('0420e7494d017f062f503253482f')
        expect(subject.sequence).to eq(4294967295)
        expect(subject.txid).to be nil
        expect(subject.vout).to be nil
        expect(subject.script_sig_asm).to be nil
        expect(subject.script_sig_hex).to be nil
      end
    end    
    
    context 'not coinbase' do
      before{
        Graphdb::Model::Transaction.create_from_txid('2570975c55f74f77417a3da625cf0e1903e24acdfd6c1cb51e4f3c7c0fa313f0')
      }
      subject {
        hash2 = {'txid' => '2570975c55f74f77417a3da625cf0e1903e24acdfd6c1cb51e4f3c7c0fa313f0','vout' => 0,
                 'scriptSig' => {
                     'asm' => '0 3045022100d2febb5bb4656bf7330c752fae99cd3515fadbc57310153e59710a6d0ba043ed022002171ab44c1e248e13afc528b836423abb637f320baaee5549f2161c69b5787801 304402204e4ab1335f98524518e445b0a159cc7088c468b611a1be201254b348fef63bd202207517615222e43f2b494f745986a25147b24557f73537b37e627aac81ada3759d01 5221020509d150da5c1b6f37b0e642cc671f766fece16862040213001a0834b0ae360c2102529a7fca66a04e460ab0dd02684698eb7ec71cc5f8a71496c152584f6c63b4c852ae',
                     'hex' => '00483045022100d2febb5bb4656bf7330c752fae99cd3515fadbc57310153e59710a6d0ba043ed022002171ab44c1e248e13afc528b836423abb637f320baaee5549f2161c69b578780147304402204e4ab1335f98524518e445b0a159cc7088c468b611a1be201254b348fef63bd202207517615222e43f2b494f745986a25147b24557f73537b37e627aac81ada3759d01475221020509d150da5c1b6f37b0e642cc671f766fece16862040213001a0834b0ae360c2102529a7fca66a04e460ab0dd02684698eb7ec71cc5f8a71496c152584f6c63b4c852ae'
                 },'sequence' => 4294967295}
        Graphdb::Model::TxIn.create_from_hash(hash2)
      }
      it do
        expect(subject.coinbase).to be nil
        expect(subject.sequence).to eq(4294967295)
        expect(subject.txid).to eq('2570975c55f74f77417a3da625cf0e1903e24acdfd6c1cb51e4f3c7c0fa313f0')
        expect(subject.vout).to eq(0)
        expect(subject.script_sig_asm).to eq('0 3045022100d2febb5bb4656bf7330c752fae99cd3515fadbc57310153e59710a6d0ba043ed022002171ab44c1e248e13afc528b836423abb637f320baaee5549f2161c69b5787801 304402204e4ab1335f98524518e445b0a159cc7088c468b611a1be201254b348fef63bd202207517615222e43f2b494f745986a25147b24557f73537b37e627aac81ada3759d01 5221020509d150da5c1b6f37b0e642cc671f766fece16862040213001a0834b0ae360c2102529a7fca66a04e460ab0dd02684698eb7ec71cc5f8a71496c152584f6c63b4c852ae')
        expect(subject.script_sig_hex).to eq('00483045022100d2febb5bb4656bf7330c752fae99cd3515fadbc57310153e59710a6d0ba043ed022002171ab44c1e248e13afc528b836423abb637f320baaee5549f2161c69b578780147304402204e4ab1335f98524518e445b0a159cc7088c468b611a1be201254b348fef63bd202207517615222e43f2b494f745986a25147b24557f73537b37e627aac81ada3759d01475221020509d150da5c1b6f37b0e642cc671f766fece16862040213001a0834b0ae360c2102529a7fca66a04e460ab0dd02684698eb7ec71cc5f8a71496c152584f6c63b4c852ae')
        expect(subject.out_point.n).to eq(0)
        expect(subject.out_point.value).to eq(0.00400000)
      end
    end
  end

end