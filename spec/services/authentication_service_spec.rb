describe AuthenticationService do
  subject { AuthenticationService.new }

  describe '#initialize' do
    it 'initializes' do
      expect { AuthenticationService.new }.to_not raise_error
    end
  end

  describe '#authenticate' do
    let(:account)  { spy('account') }
    let(:auth)     { spy('auth') }

    context 'success' do
      before do
        allow(User).to receive(:find_or_create_by).and_return account
        subject.authenticate auth
      end

      it 'finds account' do
        expect(User).to have_received(:find_or_create_by)
          .with hash_including(facebook_id: anything) 
      end

      it 'updates firstname' do
        expect(account).to have_received(:update)
          .with hash_including(firstname: anything)
      end

      it 'updates lastname' do
        expect(account).to have_received(:update)
          .with hash_including(lastname: anything)
      end

      it 'updates email' do
        expect(account).to have_received(:update)
          .with hash_including(email: anything)
      end

      it 'updates address' do
        expect(account).to have_received(:update)
          .with hash_including(address: anything)
      end

      it 'broadcasts success' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:success)
      end
    end

    context 'exception' do
      before do
         allow(User).to receive(:find_or_create_by).and_raise :error 
      end

      it 'broadcasts fail' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:fail)
      end
    end

    context 'address NameError exception' do
      before do
        allow(User).to receive(:find_or_create_by).and_return account
        allow(auth).to receive(:address).and_raise NameError
      end

      it 'broadcasts success' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:success)
      end
    end
  end
end 