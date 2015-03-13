describe RecommendationForm do
  subject { RecommendationForm.new Recommendation.new, practitioner }

  let(:practitioner)    { build_stubbed :practitioner }
  let(:attributes)      { attributes_for :recommendation_form }
  let(:recommendation)  { subject.recommendation}

  describe '#initialize', focus: true do
    it 'initializes with recommendation and practitioner' do
      expect { RecommendationForm.new Recommendation.new, practitioner }.to_not raise_error
    end

    it 'errors without practitioner' do
      expect { RecommendationForm.new Recommendation.new }.to raise_error
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
      before do
        allow(subject).to receive(:save)
        subject.next_step
      end

      it 'saves form' do
        expect(subject).to have_received(:save)
      end
    end
  end

  describe '#form_fields' do
    context 'step_one' do
      it 'has form fields' do
        expect(subject.form_fields).to eq [:practitioner_id, :practitioner_name, :user, :patient_type, :profession, :address]
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
    context 'step_one' do
      before do
        allow(recommendation).to receive(:update_attributes)
        allow(practitioner).to receive(:update_attributes)
      end

      context 'existing practitioner' do
        before do
          subject.attributes = attributes
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
            .with hash_including(profession: attributes[:profession]) 
        end

        it 'updates recommendation with patient_type' do
          expect(recommendation).to have_received(:update_attributes)
            .with hash_including(patient_type_ids: [ attributes[:patient_type] ] ) 
        end

        it 'does NOT update practitioner' do
          expect(practitioner).to_not have_received(:update_attributes)
        end
      end

      context 'new practitioner' do
        let(:practitioner) { build_stubbed :empty_practitioner }

        before do
          allow(practitioner).to receive(:fullname=)
          allow(practitioner).to receive(:address=)
          allow(practitioner).to receive(:add_occupation)

          subject.attributes = attributes.merge(practitioner_name: 'New Practitioner' )
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
            .with hash_including(profession: attributes[:profession]) 
        end

        it 'update practitioner to not_indexed' do
          expect(pactitioner).to have_received(:not_indexed!)
        end
  
        it 'updates practitioner with practitioner_name' do
          expect(pactitioner).to have_received(:fullname=)
            .with attributes[:practitioner_name]
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

      context 'modifying practitioner' do
        
      end
    end

    context 'step_two' do
      before do
        allow(recommendation).to receive(:update_attributes)
        
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
        expect(practitioner).to_not have_received(:update_attributes)
      end
    end

  
    context 'modifying practitioner' do
      before do
        allow(practitioner).to have_received(:not_indexed!)
        allow(practitioner).to have_received(:fullname=)
        allow(practitioner).to have_received(:address=)
      end

      context 'modifying existing practitioner' do
        it 'sets practitioner to not_indexed' do
          expect(pactitioner).to have_received(:not_indexed!)
        end
  
        it 'updates practitioner with name' do
          expect(pactitioner).to have_received(:fullname=)
            .with attributes[:practitioner_name]
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

      context 'new practitioner' do
        it 'creates a pactitioner' do
          expect(Practitioner).to have_received(:find_or_create_by)
            .with hash_including(id: attributes[:practitioner_id])
        end
  
        it 'sets practitioner to not_indexed' do
          expect(pactitioner).to have_received(:not_indexed!)
        end
  
        it 'updates practitioner with name' do
          expect(pactitioner).to have_received(:set_name)
            .with attributes[:practitioner_name]
        end
  
        it 'update practitioner with address' do
          expect(practitioner).to have_received(:address)
            .with attributes[:address]
        end
  
        it 'update practitioner with occupation' do
          expect(practitioner).to have_received(:add_occupation)
            .with attributes[:profession]
        end
      end
    end

    context 'multiple writes' do
      pending
    end
  end
end