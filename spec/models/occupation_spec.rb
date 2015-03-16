describe Occupation do
  describe '#initialize' do
    it 'initializes' do
      expect{ Occupation.new }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a experience' do
      expect(subject).to respond_to :experience
    end

    it 'delegates name to profession' do
      expect(subject).to delegate_method(:name).to(:profession)
    end
  end

  describe 'associations' do
    it 'belongs to practitioner' do
      expect(subject).to belong_to(:practitioner)
    end

    it 'belongs to profession' do
      expect(subject).to belong_to(:profession)
    end
  end


end
