describe 'practitioner' do
  describe 'autocomplete' do
    let(:practitioner) { build_stubbed :practitioner }
    let(:results)      { OpenStruct.new(results: [ practitioner ]) }
    
    before do
      allow(Practitioner).to receive(:search).and_return results
      xhr :get, practitioners_autocomplete_path(query: 'a'), format: :json
    end
    
    it 'returns id' do
      expect(json.first['id']).to_not be_blank
    end

    it 'returns fullname' do
      expect(json.first['fullname']).to eq(practitioner.fullname)
    end 

    it 'returns address' do
      expect(json.first['address']).to eq(practitioner.address)
    end 

    it 'returns profession_name' do
      expect(json.first['profession_name']).to eq(practitioner.primary_occupation.name)
    end 
  end
end