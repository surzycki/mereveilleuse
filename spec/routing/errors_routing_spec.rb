describe 'ErrorsRouting' do
  describe 'routes' do
    it 'has route to 404' do
      expect(get: '/404').to route_to(
        controller:    'errors',
        action:        'not_found',
        status:        404
      )
    end

    it 'has route to 422' do
      expect(get: '/422').to route_to(
        controller:    'errors',
        action:        'unprocessable_entity'
      )
    end

    it 'has route to 500' do
      expect(get: '/500').to route_to(
        controller:    'errors',
        action:        'internal_server_error'
      )
    end
  end

  describe 'paths' do
    it 'has 404 path' do
      expect(not_found_path).to eq('/404')
    end

    it 'has 422 path' do
      expect(unprocessable_entity_path).to eq('/422')
    end

    it 'has 500 path' do
      expect(internal_server_error_path).to eq('/500')
    end
  end
end 