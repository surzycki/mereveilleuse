#describe RecommendationWizard, focus: true do
#  
#  subject { RecommendationWizard.new form }
#  
#  let(:form) { spy('form') }
#
#  describe 'initialize' do
#    it 'intiializes with form' do
#      expect { RecommendationWizard.new form }.to_not raise_error
#    end
#
#    it 'errors without form' do
#      expect { RecommendationWizard.new }.to raise_error
#    end
#  end
#
#  describe 'attributes' do
#    it 'has a form' do
#      expect(subject).to respond_to :form
#    end
#  end
#
#  describe '#execute' do
#    let(:attributes) { spy ('attributes') }
#
#    context 'next_step' do
#      before do
#        allow(form).to receive(:next_step).and_return true
#       
#        subject.execute attributes
#      end
#
#      it 'sets attributes on form' do
#        expect(form).to have_received(:attributes=) 
#          .with attributes
#      end
#
#      it 'triggers on_next_step event' do
#        expect(listener).to have_received(:on_next_step)
#          .with form.recommendation  
#      end
#
#      it 'does NOT trigger on_form_complete event' do
#        expect(listener).to_not have_received(:on_form_complete)
#      end
#
#      it 'does NOT trigger on_form_error event' do
#        expect(listener).to_not have_received(:on_form_error)
#      end
#    end
#
#    context 'completed' do
#      before do
#        allow(form).to receive(:next_step).and_return true
#        allow(form).to receive(:state).and_return 'completed'
#
#        RecommendationWizard.new(listener).tap { |wizard| wizard.set form, attributes }
#      end
#
#      it 'triggers on_form_complete event' do
#        expect(listener).to have_received(:on_form_complete)
#          .with form.recommendation  
#      end
#
#      it 'does NOT trigger on_next_step event' do
#        expect(listener).to_not have_received(:on_next_step)
#      end
#
#      it 'does NOT trigger on_form_error event' do
#        expect(listener).to_not have_received(:on_form_error)
#      end
#    end
#
#    context 'failure' do
#      before do
#        allow(form).to receive(:next_step).and_return false
#        allow(listener).to receive(:on_form_error)
#
#        RecommendationWizard.new(listener).tap { |wizard| wizard.set form, attributes }
#      end
#
#      it 'triggers on_form_error event' do
#        expect(listener).to have_received(:on_form_error)
#          .with form.errors  
#      end
#
#      it 'does NOT trigger on_next_step event' do
#        expect(listener).to_not have_received(:on_next_step)
#      end
#
#      it 'does NOT trigger on_form_complete event' do
#        expect(listener).to_not have_received(:on_form_complete)
#      end
#    end
#  end
#end