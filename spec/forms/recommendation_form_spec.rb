describe RecommendationForm do
  subject { RecommendationForm.new params }

  let(:params) { spy('params') }

  describe '#initialize' do
    it 'initializes with params' do
      expect { RecommendationForm.new params }.to_not raise_error
    end
  end

  describe 'attributes' do
    it 'has a user_id' do 
      expect(subject).to respond_to :user_id
    end

    it 'has a practitioner_name' do 
      expect(subject).to respond_to :practitioner_name
    end

    it 'has a patient_type_id' do 
      expect(subject).to respond_to :patient_type_id
    end

    it 'has a profession_name' do 
      expect(subject).to respond_to :profession_name
    end

    it 'has an address' do 
      expect(subject).to respond_to :address
    end

    it 'has a wait_time' do 
      expect(subject).to respond_to :wait_time
    end

    it 'has a availability' do 
      expect(subject).to respond_to :availability
    end

    it 'has a bedside_manner' do 
      expect(subject).to respond_to :bedside_manner
    end

    it 'has a efficacy' do 
      expect(subject).to respond_to :efficacy
    end

    it 'has a comment' do 
      expect(subject).to respond_to :comment
    end
  end

  describe 'validations' do
    it 'validates presense of user_id' do
      expect(subject).to validate_presence_of :user_id
    end

    it 'validates presense of practitioner_name' do
      expect(subject).to validate_presence_of :practitioner_name
    end

    it 'validates presense of patient_type_id' do
      expect(subject).to validate_presence_of :patient_type_id
    end

    it 'validates presense of profession_name' do
      expect(subject).to validate_presence_of :profession_name
    end

    it 'validates presense of address' do
      expect(subject).to validate_presence_of :address
    end

    it 'validates presense of wait_time' do
      expect(subject).to validate_presence_of :wait_time
    end

    it 'validates presense of availability' do
      expect(subject).to validate_presence_of :availability
    end

    it 'validates presense of bedside_manner' do
      expect(subject).to validate_presence_of :bedside_manner
    end

    it 'validates presense of efficacy' do
      expect(subject).to validate_presence_of :efficacy
    end
  end

  describe '#process' do
    let(:recommendation) { spy('recommendation') }
    let(:practitioner)   { spy('practitioner') }

    before do
      allow(Recommendation).to receive(:new).and_return recommendation
      allow(Practitioner).to receive(:find_by_fullname).and_return practitioner
      allow(subject).to receive(:update_practitioner)
    end

    context 'success' do
      before do
        allow(subject).to receive(:valid?).and_return true
        allow(subject).to receive(:update_practitioner)
        allow(recommendation).to receive(:save).and_return true
      
        subject.process
      end

      it 'updates practitioner' do
        expect(subject).to have_received(:update_practitioner)
      end

      it 'returns true' do
        expect(subject.process).to be true
      end
    end

    context 'fail' do
      before do
        allow(subject).to receive(:valid?).and_return false
        allow(recommendation).to receive(:save).and_return true
      
        subject.process
      end

      it 'does NOT update practitioner' do
        expect(subject).to_not have_received(:update_practitioner)
      end

      it 'returns false' do
        expect(subject.process).to be false
      end
    end

    context 'general exception' do
      before do
        allow(subject).to receive(:valid?).and_raise :error
      
        subject.process
      end

      it 'does NOT update practitioner' do
        expect(subject).to_not have_received(:update_practitioner)
      end

      it 'returns false' do
        expect(subject.process).to be false
      end

      it 'adds to error object' do
        expect(subject.errors.full_messages).to include I18n.t('errors.general')
      end
    end

    context 'NameError exception' do
      before do
        allow(subject).to receive(:valid?).and_raise NameError
      
        subject.process
      end

      it 'does NOT update practitioner' do
        expect(subject).to_not have_received(:update_practitioner)
      end

      it 'returns false' do
        expect(subject.process).to be false
      end

      it 'adds to error object' do
        expect(subject.errors.full_messages).to include "À l'adresse introuvable"
      end
    end
  end
end