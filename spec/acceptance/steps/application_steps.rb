module ApplicationSteps
  step 'I am logged in' do
    integration_sign_in(User.first || FactoryGirl.create(:user))
  end

  step 'I am logged in as admin' do
    account = FactoryGirl.create :admin_user
    integration_sign_in account, :admin_user 
  end

  step 'the application is setup' do
    clear_emails
    
    FactoryGirl.create :profession,   name: 'Doctor'
    FactoryGirl.create :patient_type, name: 'Person'
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

  step 'a search service is running for recommendation' do 
    recommendation = FactoryGirl.create :recommendation
    allow(Recommendation).to receive(:search).and_return(OpenStruct.new results: [recommendation])
  end

  step 'I should be on the search success page' do
    expect(current_path).to eq(search_path)
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

  step 'I :whether_to be on search unsubscribe location' do |positive|
    expectation = positive ? :to : :not_to

    search = Search.first
  
    user   = search.user
    url    = unsubscribe_search_path(user.login_token,search)

    expect(current_path).send expectation, eq(url)
  end

  step 'the Facebook :pixel_type conversion pixel :whether_to be fired' do |pixel_type, positive|
    expectation = positive ? :to : :not_to
    text = "facebook conversion code for #{pixel_type.downcase}"
    
    expect(page.body).send expectation, include(text)
  end
end

RSpec.configure do |config| 
  config.include ApplicationSteps
  config.include ApplicationHelper
  config.include RequestHelpers
end