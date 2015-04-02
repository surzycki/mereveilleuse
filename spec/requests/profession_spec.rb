describe 'profession' do
  describe 'autocomplete' do
    let(:profession)  { build_stubbed :profession }
    let(:results)     { OpenStruct.new(results: [ profession ]) }
    
    before do
      allow(Profession).to receive(:search).and_return results
      xhr :get, professions_autocomplete_path(query: 'a'), format: :json
    end
    
    it 'returns id' do
      expect(json.first['id']).to_not be_blank
    end

    it 'returns name' do
      expect(json.first['name']).to eq(profession.name)
    end 
  end
end