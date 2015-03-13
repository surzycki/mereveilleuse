describe RecommendationForm do
  subject { RecommendationForm.new Recommendation.new, practitioner }

  let(:practitioner)    { build_stubbed :practitioner }
  let(:recommendation)  { subject.recommendation}

  let(:attributes) { 
    {
      practitioner_name:  practitioner.fullname,
      practitioner_id:    practitioner.id,
      patient_type:       '2',
      profession:         practitioner.primary_occupation.try(:id),
      address:            practitioner.address,
      user:               '1',
      wait_time:          '1',
      availability:       '1',
      bedside_manner:     '1',
      efficacy:           '1',
      comment:            '1'
    }
  }

  describe '#initialize' do
    it 'initializes with recommendation and practitioner' do
      expect { RecommendationForm.new Recommendation.new, practitioner }.to_not raise_error
    end

    it 'implicit initialization of practitioner' do
      allow(Practitioner).to receive(:new)
      RecommendationForm.new Recommendation.new
      expect(Practitioner).to have_received(:new)
    end

    it 'implicit initialization of recommendation' do
      allow(Recommendation).to receive(:new)
      RecommendationForm.new 
      expect(Recommendation).to have_received(:new)
    end
  end

  describe 'attributes' do
    it 'has a practitioner' do 
      expect(subject).to respond_to :practitioner
    end

    it 'has a practitioner_name' do 
      expect(subject).to respond_to :practitioner_name
    end

    it 'has a user' do
      expect(subject).to respond_to :user
    end

    it 'has a patient_type' do 
      expect(subject).to respond_to :patient_type
    end

    it 'has a profession' do 
      expect(subject).to respond_to :profession
    end

    it 'has a address' do 
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

    it 'has a state' do
      expect(subject).to respond_to :state
    end    
  end

  describe 'validations' do
    context 'step one' do
      before { subject.state = 'step_one' }

      it 'validates presense of practitioner_name' do
        expect(subject).to validate_presence_of :practitioner_name
      end

      it 'validates presense of practitioner_id' do
        expect(subject).to validate_presence_of :practitioner_id
      end

      it 'validates presense of user' do
        expect(subject).to validate_presence_of :user
      end

      it 'validates presense of patient_type' do
        expect(subject).to validate_presence_of :patient_type
      end

      it 'validates presense of profession' do
        expect(subject).to validate_presence_of :profession
      end

      it 'validates presense of address' do
        expect(subject).to validate_presence_of :address
      end
    end

    context 'step two' do
      before { subject.state = 'step_two' }

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
  end

  describe 'state machine' do
    context 'new form' do
      it 'starts with step_one' do
        expect(subject.state).to eq 'step_one'
      end
  
      it 'transitions to step_two' do
        expect(subject.next_step_transition.to).to eq 'step_two'
      end
    end

    context 'step two' do
      it 'transitions to step_three ' do
        subject.state = 'step_two'
        expect(subject.next_step_transition.to).to eq 'step_three'
      end
    end

    context 'entering step_three' do
      it 'transitions to completed' do
        subject.state = 'step_three'
        expect(subject.next_step_transition.to).to eq 'completed'
      end
    end
  end

  describe 'transition callbacks' do
    context 'before transition' do
      before do
        allow(subject).to receive(:valid?)
        subject.next_step
      end
      
      it 'checks form validity' do
        expect(subject).to have_received(:valid?)
      end
    end

    context 'after transition' do
      context 'when valid' do
        before do
          allow(subject).to receive(:save)
          allow(subject).to receive(:valid?).and_return true
          subject.next_step
        end
        
        it 'saves form' do
          expect(subject).to have_received(:save)
        end
      end

      context 'when invalid' do
        before do
          allow(subject).to receive(:save)
          allow(subject).to receive(:valid?).and_return false
          subject.next_step
        end

        it 'does NOT save form' do
          expect(subject).to_not have_received(:save)
        end
      end
    end
  end

  describe '#form_fields' do
    context 'step_one' do
      it 'has form fields' do
        expect(subject.form_fields).to eq [:practitioner_name, :user, :patient_type, :profession, :address]
      end
    end

    context 'step_two' do
      it 'has form fields' do
        subject.state = 'step_two'
        expect(subject.form_fields).to eq [:wait_time, :availability, :bedside_manner, :efficacy, :comment]
      end
    end

    context 'step_three' do
      
    end
  end

  describe '#save' do
    before do
      allow(practitioner).to receive(:not_indexed!)
      allow(recommendation).to receive(:update_attributes)
    end

    context 'step_one' do
      context 'with practitioner in database' do
        before do
          subject.attributes = attributes
          subject.save
        end
        
        it 'updates recommendation with practitioner_id' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(practitioner_id: attributes[:practitioner_id]) 
        end 
  
        it 'updates recommendation with user' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(user: attributes[:user]) 
        end
  
        it 'updates recommendation with profession' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(profession: attributes[:profession] ) 
        end

        it 'updates recommendation with patient_type' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(patient_type_ids: [ attributes[:patient_type] ] ) 
        end

        it 'does NOT update practitioner' do
          expect(practitioner).to_not have_received(:not_indexed!)
        end
      end

      context 'when new practitioner' do
        let(:practitioner) { Practitioner.create }

        before do
          allow(practitioner).to receive(:fullname=)
          allow(practitioner).to receive(:address=)
          allow(practitioner).to receive(:add_occupation)
        
          subject.attributes = attributes.merge(practitioner_name: 'New Practitioner', profession: '2', practitioner_id: practitioner.id )
          subject.save
        end

        it 'updates recommendation with practitioner_id' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(practitioner_id: practitioner.id) 
        end 
   
        it 'updates recommendation with user' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(user: attributes[:user]) 
        end
  
        it 'updates recommendation with profession' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(profession: '2') 
        end

        it 'set practitioner to not_indexed' do
          expect(practitioner).to have_received(:not_indexed!)
        end
  
        it 'updates practitioner with practitioner_name' do
          expect(practitioner).to have_received(:fullname=)
            .with 'New Practitioner'
        end
  
        it 'update practitioner with address' do
          expect(practitioner).to have_received(:address=)
            .with attributes[:address]
        end
  
        it 'update practitioner with occupation' do
          expect(practitioner).to have_received(:add_occupation)
            .with '2'
        end
      end

      context 'when modifying in database practitioner' do
        before do
          allow(practitioner).to receive(:fullname=)
          allow(practitioner).to receive(:address=)
          allow(practitioner).to receive(:add_occupation)
        
          subject.attributes = attributes.merge(practitioner_name: 'Updated Practitioner' )
          subject.save
        end

        it 'updates recommendation with practitioner_id' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(practitioner_id: attributes[:practitioner_id]) 
        end 
   
        it 'updates recommendation with user' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(user: attributes[:user]) 
        end
  
        it 'updates recommendation with profession' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(profession: attributes[:profession]) 
        end

        it 'set practitioner to not_indexed' do
          expect(practitioner).to have_received(:not_indexed!)
        end
  
        it 'updates practitioner with practitioner_name' do
          expect(practitioner).to have_received(:fullname=)
            .with 'Updated Practitioner'
        end
  
        it 'update practitioner with address' do
          expect(practitioner).to have_received(:address=)
            .with attributes[:address]
        end
  
        it 'update practitioner with occupation' do
          expect(practitioner).to have_received(:add_occupation)
            .with attributes[:profession]
        end
      end
    end

    context 'step_two' do
      before do
        subject.state      = 'step_two'
        subject.attributes = attributes
        subject.save
      end

      it 'updates recommendation with wait_time' do
        expect(recommendation).to have_received(:update_attributes)
          .with hash_including(wait_time: attributes[:wait_time]) 
      end

      it 'updates recommendation with availability' do
        expect(recommendation).to have_received(:update_attributes)
          .with hash_including(availability: attributes[:availability]) 
      end

      it 'updates recommendation with bedside_manner' do
        expect(recommendation).to have_received(:update_attributes)
          .with hash_including(bedside_manner: attributes[:bedside_manner]) 
      end

      it 'updates recommendation with efficacy' do
        expect(recommendation).to have_received(:update_attributes)
          .with hash_including(efficacy: attributes[:efficacy]) 
      end

      it 'updates recommendation with comment' do
        expect(recommendation).to have_received(:update_attributes)
          .with hash_including(comment: attributes[:comment]) 
      end

      it 'does NOT update practitioner' do
        expect(practitioner).to_not have_received(:not_indexed!)
      end
    end

    context 'multiple writes' do
      pending
    end
  end
end