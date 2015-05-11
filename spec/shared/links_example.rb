shared_examples 'it has default has uris' do
  before do
    subject.id = 10
  end
  
  it 'has correct path' do
    path = Rails.application.routes.url_helpers.send :"#{subject.class.name.parameterize}_path", subject
    expect(subject.path).to eq(path)
  end

  it 'has correct url' do
    url = Rails.application.routes.url_helpers.send :"#{subject.class.name.parameterize}_url", subject
    expect(subject.url).to eq(url)
  end
end