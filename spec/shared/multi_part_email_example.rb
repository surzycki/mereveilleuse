shared_examples 'a multipart email' do
  it 'generates a multipart message' do 
    expect(subject.body.parts.count).to be 2
  end

  it 'generates a plain text message' do 
    content_types = subject.body.parts.collect(&:content_type)
    expect(content_types).to include('text/plain; charset=UTF-8')
  end

  it 'generates an html message' do 
    content_types = subject.body.parts.collect(&:content_type)
    expect(content_types).to include('text/html; charset=UTF-8')
  end
end