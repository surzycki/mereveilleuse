describe SearchService do 
  subject { SearchService.new form }

  let(:provider) { spy('provider') }
  let(:form)     { spy('form') }
  let(:search)   { spy('search') }
  let(:errors)   { spy('errors') }
  let(:results)  { spy('results') }

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
        allow(provider).to receive(:execute).and_return results
      end
      
      context 'with results' do
        before do
          allow(results).to receive(:present?).and_return true
        end

        it 'broadcasts search_success' do
          expect { 
            subject.execute(provider) 
          }.to broadcast(:search_success, results, search)
        end
  
        it 'executes provider' do
          subject.execute(provider)
  
          expect(provider).to have_received(:execute)
            .with search
        end
      end

      context 'with NO results' do
        before do
          allow(results).to receive(:present?).and_return false
        end

        it 'broadcasts search_no_results' do
          expect { 
            subject.execute(provider) 
          }.to broadcast(:search_no_results, search)
        end
  
        it 'executes provider' do
          subject.execute(provider)
  
          expect(provider).to have_received(:execute)
            .with search
        end
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