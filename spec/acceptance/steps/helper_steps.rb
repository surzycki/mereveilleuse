module HelperSteps
  step 'I am logged in' do
    integration_sign_in FactoryGirl.create(:user)
  end

  step 'the application is setup' do
    FactoryGirl.create :profession,   name: 'Doctor'
    FactoryGirl.create :patient_type, name: 'Person'
  end

  step 'I am on :page' do |page|
    path = case page
    when 'recommendation step one'
      new_recommendation_path
    when 'recommendation step two'
      edit_recommendation_path(Recommendation.first || 1)
    else
      root_path
    end

    visit path
  end

  step 'I :whether_to be on :page' do |positive, page|
    expectation = positive ? :to : :not_to

    path = case page
    when 'recommendation step one'
      new_recommendation_path
    when 'recommendation step two'
      edit_recommendation_path(Recommendation.first || 1)
    else
      root_path
    end

    expect(current_path).send expectation, eq(path)
  end

  step 'I modify the :model :attribute with :value' do |model_name, attribute, value|
    id = "#{model_name.underscore}_#{attribute.underscore}"
    fill_in "#{id}", with: value

    form_modifications[id.to_sym] = value
  end

  step 'I select :option from :field on :form' do |option, field, form|
    select option, from: "#{form.underscore}[#{field.underscore}]"
  end

  step 'I submit the form' do
    find(:xpath, '//input[@type="submit"]').click
  end

  step 'there :are :count :model' do |are, count, model|
    expect(model.singularize.capitalize.constantize.count).to eq count.to_i
  end

  step 'I see an error message' do
    expect(page).to have_css('.alert.flash-fixed-top.flash-notification')
  end

  step 'a practitioner :fullname exists' do |fullname|
    @practitioner = FactoryGirl.create :practitioner
    @practitioner.fullname = fullname
    @practitioner.save
  end

  step 'I :whether_to see :text' do |positive, text|
    expectation = positive ? :to : :not_to
    expect(page.body).send expectation, eq(text)
  end

  step 'show page' do
    print page.html
  end

  def form_modifications
    @form_modifications ||= {}
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