shared_examples 'a model with a fullname attribute' do
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
end