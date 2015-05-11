module PageSteps
  step 'I goto the :path page' do |path|
    path = "#{path.downcase.tr(' ', '_')}_path"
    visit route_helpers.send(path)
  end

  step 'I :whether_to be on the :path page' do |positive, path|
    expectation = positive ? :to : :not_to
    
    path = route_helpers.send "#{path.downcase.tr(' ', '_')}_path"
    
    expect(current_path).send expectation, eq(path)
  end

  step 'I goto the :model show page' do |model|
    model    = model.capitalize.constantize
    instance = model.first
    
    path = "#{model.downcase}_path"
    path  = route_helpers.send(path)

    visit path
  end

  step 'I :whether_to be on the :model show page' do |positive, model|
    expectation = positive ? :to : :not_to

    model    = model.capitalize.constantize
    instance = model.first
    
    expect(current_path).send expectation, eq(instance.path)
  end

  step 'I :whether_to be on the :path page for the :model' do |positive, path, model|
    expectation = positive ? :to : :not_to

    model    = model.capitalize.constantize
    instance = model.first
    path     = instance.send "#{path.downcase.tr(' ', '_')}_path"

    expect(current_path).send expectation, eq(path)
  end

  step 'I :whether_to see :text' do |positive, text|
    expectation = positive ? :to : :not_to
    expect(page.body).send expectation, include(text)
  end

  step 'I :whether_to see an error message' do |positive|
    expectation = positive ? :to : :not_to
    expect(page).send expectation, have_css('.alert.flash-fixed-top.flash-notification')
  end

  step 'I :whether_to see a success message' do |positive|
    expectation = positive ? :to : :not_to
    expect(page).send expectation, have_css('.flash-fixed-top.flash-notification.notice')
  end

  def route_helpers
    Rails.application.routes.url_helpers
  end
end

RSpec.configure do |config| 
  config.include PageSteps
end