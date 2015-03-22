describe SearchForm do
  subject { SearchForm.new params }

  let(:params) { spy('params') }
  let(:search) { spy('search') }

  describe '#initialize' do
    it 'initializes with params' do
      expect { SearchForm.new params }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has an address' do 
      expect(subject).to respond_to :address
    end

    it 'has a profession_id' do 
      expect(subject).to respond_to :profession_id
    end

    it 'has a patient_type_id' do 
      expect(subject).to respond_to :patient_type_id
    end

    it 'has an information' do 
      expect(subject).to respond_to :information
    end

    it 'has a user_id' do 
      expect(subject).to respond_to :user_id
    end
  end

  describe 'validations' do
    it 'validates presense of address' do
      expect(subject).to validate_presence_of :address
    end

    it 'validates presense of profession_id' do
      expect(subject).to validate_presence_of :profession_id
    end

    it 'validates presense of patient_type_id' do
      expect(subject).to validate_presence_of :patient_type_id
    end

    it 'validates presense of user_id' do
      expect(subject).to validate_presence_of :user_id
    end
  end

  describe '#process'  do
    context 'when valid' do
      before { allow(subject).to receive(:valid?).and_return true } 

      context 'with existing search' do
        before do
          allow(subject).to receive(:search_exists?).and_return true
        end

        it 'returns true' do
          expect(subject.process).to be true
        end
      end

      context 'new search' do
        before do
          allow(subject).to receive(:search_exists?).and_return false
          allow(subject).to receive(:search).and_return search
          subject.process
        end

        it 'saves search' do
          expect(search).to have_received(:save)
        end
  
        it 'returns true' do
          expect(subject.process).to be_truthy
        end
      end
    end

    context 'when invalid' do
      before do
        allow(subject).to receive(:valid?).and_return false
        subject.process
      end

      it 'does NOT save search' do
        expect(search).to_not have_received(:save)
      end

      it 'returns false' do
        expect(subject.process).to be false
      end
    end

    context 'when exception' do
      before do
        allow(subject).to receive(:valid?).and_raise :error
        subject.process
      end

      it 'does NOT save search' do
        expect(search).to_not have_received(:save)
      end

      it 'returns false' do
        expect(subject.process).to be false
      end

      it 'sets error object' do
        expect(subject.errors[:base]).to include I18n.t('errors.general')
      end
    end

    context 'when NameError' do
      before do
        allow(subject).to receive(:valid?).and_raise NameError
        subject.process
      end

      it 'does NOT save search' do
        expect(search).to_not have_received(:save)
      end

      it 'returns false' do
        expect(subject.process).to be false
      end

      it 'sets error object' do
        expect(subject.errors[:address]).to include I18n.t('errors.address_parser')
      end
    end
  end
end