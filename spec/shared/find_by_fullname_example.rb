shared_examples 'a model with a fullname finder' do
  describe 'find_by_fullname' do
    context 'successul' do
      before do
        allow(subject.class).to receive(:find_by)
        subject.class.find_by_fullname('Joe Blow')
      end
      
      it 'finds by firstname' do
        expect(subject.class).to have_received(:find_by)
          .with hash_including(firstname: 'joe')
      end
      
      it 'finds by lastname' do
        expect(subject.class).to have_received(:find_by)
          .with hash_including(lastname: 'blow')
      end
    end

    context 'not found' do
      it 'returns nil' do
        expect(subject.class.find_by_fullname('Homer Simpson')).to be_nil
      end
    end
    
    context 'unrecognized input' do
      it 'single name returns nil' do
        expect(subject.class.find_by_fullname('Simpson')).to be_nil
      end

      it 'blank returns nil' do
        expect(subject.class.find_by_fullname('')).to be_nil
      end

      it 'nil returns nil' do
        expect(subject.class.find_by_fullname).to be_nil
      end
      
      it 'strange returns nil' do
        expect(subject.class.find_by_fullname('-- -')).to be_nil
      end
    end
  end
end