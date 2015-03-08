describe Authentication do
  let(:listener) { spy('listener') }
  let(:subject)  { Authentication.new listener }

  describe '#initialize' do
    it 'initializes with listener' do
      expect { Authentication.new(listener) }.to_not raise_error
    end

    it 'errors without listener' do
      expect { Authentication.new }.to raise_error
    end
  end

  describe '#with' do
    let(:facebook_authentication) { spy('facebook_authentication') }
    let(:account)                 { spy('account') }

    before do
      allow(User).to receive(:find_or_create_by).and_return account
    end

    context 'registration' do
      before do
        allow(account).to receive(:registered?).and_return false
        subject.with facebook_authentication
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

      it 'triggers on_authentication_success' do
        expect(listener).to have_received(:on_authentication_success)
          .with account
      end

      it 'triggers on_registration_success' do
        expect(listener).to have_received(:on_registration_success)
      end
    end

    context 'login' do
      before do
        allow(account).to receive(:registered?).and_return true
        Authentication.new(listener).with facebook_authentication
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

      it 'triggers on_authentication_success' do
        expect(listener).to have_received(:on_authentication_success)
          .with account
      end

      it 'triggers on_login_success' do
        expect(listener).to have_received(:on_login_success)
      end
    end

    context 'exception' do
      before do
        allow(account).to receive(:registered?).and_raise :error
        Authentication.new(listener).with facebook_authentication
      end

      it 'triggers on_authentication_fail' do
        expect(listener).to have_received(:on_authentication_fail)
      end
    end
  end
end 