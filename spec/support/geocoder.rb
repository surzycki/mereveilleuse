Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.add_stub(
  'france', [
    {
      'latitude'     => 42.2,
      'longitude'    => 2.2,
      'address'      => 'France',
      'city'         => nil,
      'state'        => nil,
      'sub_state'    => nil,
      'state_code'   => nil,
      'country'      => 'France',
      'country_code' => 'FR',
      'postal_code'  => nil
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  'ile de france', [
    {
      'latitude'     => 42.2,
      'longitude'    => 2.2,
      'address'      => 'Île-de-France, France',
      'city'         => nil,
      'state'        => 'Île-de-France',
      'sub_state'    => nil,
      'state_code'   => 'IDF',
      'country'      => 'France',
      'country_code' => 'FR',
      'postal_code'  => nil
    }
  ]
)


Geocoder::Lookup::Test.add_stub(
  'paris', [
    {
      'latitude'     => 42.2,
      'longitude'    => 2.2,
      'address'      => 'Paris, France',
      'city'         => 'Paris',
      'state'        => 'Île-de-France',
      'sub_state'    => 'Paris',
      'state_code'   => 'IDF',
      'country'      => 'France',
      'country_code' => 'FR',
      'postal_code'  => nil
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  '75011', [
    {
      'latitude'     => 42.2,
      'longitude'    => 2.2,
      'address'      => '75011 Paris, France',
      'city'         => 'Paris',
      'state'        => 'Île-de-France',
      'sub_state'    => 'Paris',
      'state_code'   => 'IDF',
      'country'      => 'France',
      'country_code' => 'FR',
      'postal_code'  => '75011'
    }
  ]
)


Geocoder::Lookup::Test.add_stub(
  '6 rue gobert paris france', [
    {
      'latitude'     => 42.2,
      'longitude'    => 2.2,
      'address'      => '6 Rue Gobert, 75011 Paris, France',
      'city'         => 'Paris',
      'state'        => 'Île-de-France',
      'sub_state'    => 'Paris',
      'state_code'   => 'IDF',
      'country'      => 'France',
      'country_code' => 'FR',
      'postal_code'  => '75011'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  '6 Rue Gobert, 75011, Paris', [
    {
      'latitude'     => 42.2,
      'longitude'    => 2.2,
      'address'      => '6 Rue Gobert, 75011 Paris, France',
      'city'         => 'Paris',
      'state'        => 'Île-de-France',
      'sub_state'    => 'Paris',
      'state_code'   => 'IDF',
      'country'      => 'France',
      'country_code' => 'FR',
      'postal_code'  => '75011'
    }
  ]
)