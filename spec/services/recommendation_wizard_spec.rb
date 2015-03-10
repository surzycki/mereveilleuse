describe RecommendationWizard do
  subject { RecommendationWizard.new listener }
  
  let(:listener) { spy('listener') }

  describe 'initialize' do
    it 'intiializes with listener' do
      expect { RecommendationWizard.new listener }.to_not raise_error
    end

    it 'errors without listener' do
      expect { RecommendationWizard.new }.to raise_error
    end
  end

  describe 'attributes' do
    it 'has a listener' do
      expect(subject).to respond_to :listener
    end
  end

  describe '#set' do
    let(:form)       { spy ('form') }
    let(:attributes) { spy ('attributes') }

    context 'success' do
      before do
        allow(form).to receive(:next_step).and_return true
       
        RecommendationWizard.new(listener).tap { |wizard| wizard.set form, attributes }
      end

      it 'sets attributes on form' do
        expect(form).to have_received(:attributes=) 
          .with attributes
      end

      it 'triggers on_next_step event' do
        expect(listener).to have_received(:on_next_step)
          .with form.recommendation  
      end
    end

    context 'failure' do
      before do
        allow(form).to receive(:next_step).and_return false
        allow(listener).to receive(:on_form_error)

        RecommendationWizard.new(listener).tap { |wizard| wizard.set form, attributes }
      end

      it 'triggers on_form_error event' do
        expect(listener).to have_received(:on_form_error)
          .with form.errors  
      end
    end
  end
end