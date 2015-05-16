module ApplicationSteps
  step 'I am logged in' do
    integration_sign_in(User.first)
  end

  step 'I am logged in as admin' do
    account = FactoryGirl.create :admin_user
    integration_sign_in account, :admin_user 
  end

  step 'the application is setup' do
    clear_emails
    
    user                = FactoryGirl.create :user, id: 100
    profession          = FactoryGirl.create :profession,   name: 'Doctor', id: 100
    first_patient_type  = FactoryGirl.create :patient_type, name: 'Person', search_alternatives: '2', id: 1 
    second_patient_type = FactoryGirl.create :patient_type, name: 'Another Person', search_alternatives: '1', id: 2
    

    FactoryGirl.create :recommendation, 
      id: 100,
      profession: profession,
      recommender: user,
      patient_types: [first_patient_type]
  end

  step 'a user :fullname exists' do |fullname|
    @user = FactoryGirl.create :user, status: User.statuses[:unregistered] 
    @user.fullname = fullname
    @user.save
  end

  step 'I am :status' do |status|
    @user = User.first
    @user.send "#{status}!"
  end

  step 'I rate :field :value on the :form' do |field,value,form|
    find("label[for=#{underscoreize(form)}_#{field}_#{value}]").click
  end

  step 'a recommendation email was sent' do 
    search          = FactoryGirl.create(:search)
    recommendation  = FactoryGirl.create :recommendation, recommender: search.user
    
    email = RecommendationMailer.results(search, [recommendation] )
    email.header['skip_premailer'] = true

    email.deliver_now
    open_email(email.to.first)
  end

  step 'a practitioner :fullname exists' do |fullname|
    @practitioner = FactoryGirl.create :practitioner
    @practitioner.fullname = fullname
    @practitioner.save
  end

  step 'the practitioner :fullname address is :address' do |fullname, address|
    practitioner = Practitioner.find_by_fullname fullname
    expect(practitioner.address).to eq address
  end

  step 'the Facebook :pixel_type conversion pixel :whether_to be fired' do |pixel_type, positive|
    expectation = positive ? :to : :not_to
    text = "facebook conversion code for #{pixel_type.downcase}"
    
    expect(page.body).send expectation, include(text)
  end

  step 'there are no relevant recommendations' do
    recommendation_empty_response  = File.open('spec/fixtures/json/elasticsearch/recommendation_empty_response.json').read
    
    stub_request(:get, "http://www.example.com:9200/mereveilleuse-test_recommendations_test/_search").
      to_return(
        headers: { 'Content-Type' => 'application/json' },
        status: 200, 
        body: recommendation_empty_response
      )
  end
end

RSpec.configure do |config| 
  config.include ApplicationSteps
  config.include ApplicationHelper
  config.include RequestHelpers
end