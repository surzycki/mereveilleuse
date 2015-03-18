module HelperSteps
  step 'I am logged in' do
    integration_sign_in(User.first || FactoryGirl.create(:user))
  end

  step 'the application is setup' do
    FactoryGirl.create :profession,   name: 'Doctor'
    FactoryGirl.create :patient_type, name: 'Person'
  end

  step 'I am on the :path page' do |path|
    path = "#{underscoreize path}_path"
    
    visit route_helpers.send(path)
  end

  step 'I :whether_to be on the :path page' do |positive, path|
    expectation = positive ? :to : :not_to
    path        = "#{underscoreize path}_path"
    
    expect(current_path).send expectation, eq(route_helpers.send(path))
  end

  step 'I modify the :model :attribute with :value' do |model_name, attribute, value|
    id = "#{underscoreize(model_name)}_#{underscoreize(attribute)}"
    fill_in "#{id}", with: value

    form_modifications[id.to_sym] = value
  end

  step 'I select :option from :field on :form' do |option, field, form|
    select option, from: "#{underscoreize(form)}[#{underscoreize(field)}]"
  end

  step 'I choose :field :value on the :form' do |field, value, form|
    choose "#{underscoreize(form)}_#{underscoreize(field)}_#{value}"
  end

  step 'I submit the form' do
    find(:xpath, '//input[@type="submit"]').click
  end

  step 'there :are :count :model' do |are, count, model|
    expect(translate_model(model).count).to eq count.to_i
  end

  step 'I :whether_to see an error message' do |positive|
    expectation = positive ? :to : :not_to

    expect(page).send expectation, have_css('.alert.flash-fixed-top.flash-notification')
  end

  step 'I :whether_to see :text' do |positive, text|
    expectation = positive ? :to : :not_to
    expect(page.body).send expectation, include(text)
  end

  step 'show page' do
    save_page
  end

  step 'there :whether_to be a :model with :attribute :value' do |positive ,model, attribute, value|
    expectation = positive ? :to : :not_to
    klass = translate_model(model)
    expect(klass.send "find_by_#{attribute}", value).send expectation, be_truthy 
  end

  step 'there :whether_to be a :association for :model with :attribute :value' do |positive, association, model, attribute, value|
    expectation  = positive ? :to : :not_to
    klass        = translate_model(model)
    clause       = Hash[attribute, value.downcase]
    result       = klass.joins(association.pluralize.to_sym).where clause
    expect(result.count).send expectation, eq(1)
  end

  step 'a :model exists' do |model|
    FactoryGirl.create(model.downcase.to_sym)
  end

  step 'take a screenshot' do 
    screenshot
  end

  def form_modifications
    @form_modifications ||= {}
  end

  def route_helpers
    Rails.application.routes.url_helpers
  end

  def translate_model(value)
    value.singularize.capitalize.constantize
  end

  def underscoreize(value)
    value.split(' ').join('_')
  end
end

placeholder :whether_to do
  match /should not/ do
    false
  end

  match /should/ do
    true
  end
end

RSpec.configure do |config| 
  config.include RequestHelpers
  config.include HelperSteps
end