module PractitionerSteps
  step 'a practitioner :fullname exists' do |fullname|
    @practitioner = FactoryGirl.create :practitioner
    @practitioner.fullname = fullname
    @practitioner.save
  end

  step 'the practitioner :fullname address is :address' do |fullname, address|
    practitioner = Practitioner.find_by_fullname fullname
    expect(practitioner.address).to eq address
  end
end

RSpec.configure do |config|
  config.include PractitionerSteps 
end