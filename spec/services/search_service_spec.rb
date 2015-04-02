describe SearchService do 
  subject { SearchService.new form }

  let(:provider) { spy('provider') }
  let(:form)     { spy('form') }
  let(:search)   { spy('search') }
  let(:errors)   { spy('errors') }

  describe '#initialize' do
    it 'initializes with form' do
      expect { SearchService.new form }.to_not raise_error
    end

    it 'errors without form' do
      expect { SearchService.new }.to raise_error
    end
  end

  describe '#execute' do
    context 'success' do
      before do
        allow(form).to receive(:process).and_return true
        allow(form).to receive(:search).and_return search
      end
      
      it 'broadcasts success' do
        expect { 
          subject.execute(provider) 
        }.to broadcast(:search_success)
      end

      it 'executes provider' do
        subject.execute(provider)

        expect(provider).to have_received(:execute)
          .with search
      end
    end

    context 'fail' do
      before do
        allow(form).to receive(:process).and_return false
        allow(form).to receive(:errors).and_return errors
      end
      
      it 'broadcasts fail' do
        expect { 
          subject.execute(provider) 
        }.to broadcast(:search_fail)
      end

      it 'does NOT execute provider' do
        subject.execute(provider)
        
        expect(provider).to_not have_received(:execute)
      end
    end
  end
end