module FormSteps
  step 'I click on :id' do |id|
    click_on(id)
  end

  step 'I click on :id and send emails' do |id|
    perform_enqueued_jobs do
      click_on(id)
    end
  end

  step 'I select :option from :field on :form' do |option, field, form|
    select option, from: "#{underscoreize(form)}[#{underscoreize(field)}]"
  end

  step 'I choose :field :value on the :form' do |field, value, form|
    choose "#{underscoreize(form)}_#{underscoreize(field)}_#{value}"
  end

  step 'I modify the :model :attribute with :value' do |model_name, attribute, value|
    id = "#{underscoreize(model_name)}_#{underscoreize(attribute)}"
    fill_in "#{id}", with: value

    form_modifications[id.to_sym] = value
  end

  step 'I submit the form' do
    find(:xpath, '//input[@type="submit"]').click
  end

  step ':field should be marked as invalid' do |field|
    expectation = find("label[for='#{field}']")['data-error']
    expect(expectation).to eq 'true'
  end

  def form_modifications
    @form_modifications ||= {}
  end
end

RSpec.configure do |config| 
  config.include FormSteps
  config.include ActiveJob::TestHelper
end