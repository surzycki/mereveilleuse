# spec is dependent upon geocoder stub
describe 'search' do
  let!(:user)          { create :user }
  let!(:patient_type)  { create :patient_type } 
  let!(:practitioner)  { create :practitioner }

  before do 
    integration_sign_in user 
  end

  describe 'create' do
    context 'new search' do
      it 'creates search' do
      end

      it 'schedules an email' do
      end
    end

    context 'duplicate search' do
      it 'does NOT create a search' do
      end

      it 'does NOT schedule an email' do
      end
    end
  end

  describe 'destroy' do
    pending
  end
end