shared_examples 'a person with a name' do
  describe '.find_by_fullname' do
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

  describe '#fullname=' do
    it 'parses standard names' do
      subject.fullname = 'Bob Jones'
      expect(subject.firstname).to eq 'Bob'
      expect(subject.lastname).to eq 'Jones'
    end

    it 'parses hyphenated names' do
      subject.fullname = 'Jean-Pierre Jones'
      expect(subject.firstname).to eq 'Jean Pierre'
      expect(subject.lastname).to eq 'Jones'
    end

    it 'parses compount names' do
      subject.fullname = 'Jean Pierre Jones'
      expect(subject.firstname).to eq 'Jean Pierre'
      expect(subject.lastname).to eq 'Jones'
    end
  end

  describe '#fullname' do
    it 'returns fullname' do
      expect(subject.fullname).to eq "#{subject.firstname} #{subject.lastname}"
    end
  end

  describe '#firstname' do
    it 'returns firstname capitalized' do
      person = build_stubbed described_class.name.downcase.to_sym, firstname: 'BOB'
      expect(person.firstname).to eq 'Bob'
    end

    it 'no firstname returns nil' do
      person = build_stubbed described_class.name.downcase.to_sym, firstname: nil
      expect(person.firstname).to be_nil
    end
  end

   describe '#lastname' do
    it 'returns lastname capitalized' do
      person = build_stubbed described_class.name.downcase.to_sym, lastname: 'JONES'
      expect(person.lastname).to eq 'Jones'
    end

    it 'no lastname returns nil' do
      person = build_stubbed described_class.name.downcase.to_sym, lastname: nil
      expect(person.lastname).to be_nil
    end
  end
end