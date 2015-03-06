describe SignedRequest do 
  let(:signed_facebook_request)   { 'DcCDt9DB34WDVX58mKXC5Wiv-YxnaVOgJ5f0PJauxc0.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjE0MjU2Njg0MDAsImlzc3VlZF9hdCI6MTQyNTY2MTg0NCwib2F1dGhfdG9rZW4iOiJDQUFNV2V5UHZJcFVCQUw0VmVDZjJxMzBsa1RXWGJGejFkek13ejZCaUt4eWJnSEZ1WkM4WkFnWUR1eE5sb3R0R2VmQzlRZEJaQThRVldQcDhwN1FwaERUNERjWkN4U1lzYXBjQVRQeXo1RDN1MWJQV255UTdzR2hrZlB1WkNZQ2xaQm5GM2VHT01aQWtYRndWSlBGUHBTQldzQmJ6ZnFVbkRJTDlYWkNWdzFQOG5GRTdEa1J5YUhHbDBPaWE3dmdaQ2FPMGN4ZHZoZVpDYmZEazZVTURUcFdpSkZuVm9aQjl1cjBsUGdaRCIsInVzZXIiOnsiY291bnRyeSI6ImZyIiwibG9jYWxlIjoiZW5fVVMiLCJhZ2UiOnsibWluIjoyMX19LCJ1c2VyX2lkIjoiMTAxNTMyMDE4MzY0MDkzMTkifQ' }
  let(:subject)                   { SignedRequest.new signed_facebook_request }

  describe '#initialize' do
    it 'initializes with parameter' do
      expect { SignedRequest.new('1234') }.to_not raise_error
    end

    it 'errors without parameter' do
      expect { SignedRequest.new }.to raise_error
    end
  end

  describe 'attributes' do
    it 'has a signed_request' do
      expect(subject).to respond_to :signed_request
    end

    it 'has an oauth_token' do
      expect(subject).to respond_to :oauth_token
    end

    it 'has an algorithm' do
      expect(subject).to respond_to :algorithm
    end

    it 'has an expires' do
      expect(subject).to respond_to :expires
    end

    it 'has an issued_at' do
      expect(subject).to respond_to :issued_at
    end

    it 'has a country' do
      expect(subject).to respond_to :country
    end

    it 'has a locale' do
      expect(subject).to respond_to :locale
    end

    it 'has a user_id' do
      expect(subject).to respond_to :user_id
    end
  end

  describe 'sets attributes' do
    it 'sets a signed_request' do
      expect(subject.signed_request).to eq(signed_facebook_request)
    end

    it 'sets a oauth_token' do
      expect(subject.oauth_token).to eq('CAAMWeyPvIpUBAL4VeCf2q30lkTWXbFz1dzMwz6BiKxybgHFuZC8ZAgYDuxNlottGefC9QdBZA8QVWPp8p7QphDT4DcZCxSYsapcATPyz5D3u1bPWnyQ7sGhkfPuZCYClZBnF3eGOMZAkXFwVJPFPpSBWsBbzfqUnDIL9XZCVw1P8nFE7DkRyaHGl0Oia7vgZCaO0cxdvheZCbfDk6UMDTpWiJFnVoZB9ur0lPgZD')
    end

    it 'sets a algorithm' do
      expect(subject.algorithm).to eq('HMAC-SHA256')
    end

    it 'sets a expires' do
      expect(subject.expires).to eq(1425668400)
    end

    it 'sets a issued_at' do
      expect(subject.issued_at).to eq(1425661844)
    end

    it 'sets a country' do
      expect(subject.country).to eq('fr')
    end

    it 'sets a locale' do
      expect(subject.locale).to eq('en_US')
    end

    it 'sets a user_id' do
      expect(subject.user_id).to eq('10153201836409319')
    end
  end 

  describe '#valid_signature?' do
    context 'confirmed signature' do
      it 'returns true' do
        expect(subject.valid_signature?).to be true
      end
    end

    context 'un-confirmed signature' do
      let(:signed_facebook_request) { 'hello' }
      
      it 'returns false' do
        expect(subject.valid_signature?).to be false
      end
    end
  end
end