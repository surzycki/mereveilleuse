describe AuthenticationService do
  subject { AuthenticationService.new }

  describe '#initialize' do
    it 'initializes' do
      expect { AuthenticationService.new }.to_not raise_error
    end
  end

  describe '#authenticate' do
    let(:account)  { spy('account') }
    let(:auth)     { spy('auth', redirect_path: 'redirect_path') }

    before do
      allow(User).to receive(:find_or_create_by).and_return account
    end

    context 'login' do
      before do
        allow(account).to receive(:registered?).and_return true
        allow(auth).to receive(:authenticated).and_return true

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

      it 'updates profile_image' do
        expect(account).to have_received(:update)
          .with hash_including(profile_image: anything)
      end

      it 'updates address' do
        expect(account).to have_received(:update)
          .with hash_including(address: anything)
      end

      it 'broadcasts login' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:login, account, auth.redirect_path )
      end
    end

    context 'signup' do
      before do
        allow(account).to receive(:registered?).and_return false
        allow(auth).to receive(:authenticated).and_return true

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

      it 'updates profile_image' do
        expect(account).to have_received(:update)
          .with hash_including(profile_image: anything)
      end

      it 'updates address' do
        expect(account).to have_received(:update)
          .with hash_including(address: anything)
      end

      it 'broadcasts login' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:signup, account )
      end
    end

    context 'request authentication' do
      before do
        allow(account).to receive(:registered?).and_return false
        allow(auth).to receive(:authenticated).and_return false

        subject.authenticate auth
      end

      it 'does NOT find account' do
        expect(User).to_not have_received(:find_or_create_by) 
      end

      it 'broadcasts request_authentication' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:request_authentication, auth )
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
        allow(auth).to receive(:address).and_raise NameError
        allow(account).to receive(:registered?).and_return true
        allow(auth).to receive(:authenticated).and_return true
      end

      it 'broadcasts login' do
        expect { 
          subject.authenticate(auth) 
        }.to broadcast(:login, account, auth.redirect_path)
      end
    end
  end
end 