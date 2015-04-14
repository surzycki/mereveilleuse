module PageSteps
  step 'I goto the :path page' do |path|
    path = "#{path.downcase.tr(' ', '_')}_path"
    visit route_helpers.send(path)
  end

  step 'I :whether_to be on the :path page' do |positive, path|
    expectation = positive ? :to : :not_to
    path = "#{path.downcase.tr(' ', '_')}_path"
    url  = route_helpers.send(path)

    expect(current_path).send expectation, eq(url)
  end

  step 'I :whether_to be on the :path page for the :model' do |positive, path, model|
    expectation = positive ? :to : :not_to
    
    path     = "#{path.downcase.tr(' ', '_')}_path"
    instance = (model.capitalize.constantize).all.first

    url  = route_helpers.send(path, instance)

    expect(current_path).send expectation, eq(url)
  end

  step 'I :whether_to be on the :path page for the :model identified by :property' do |positive, path, model, property|
    expectation = positive ? :to : :not_to
    
    path     = "#{path.downcase.tr(' ', '_')}_path"
    instance = (model.capitalize.constantize).all.first
    property = instance.send(property)

    url  = route_helpers.send(path, property)

    expect(current_path).send expectation, eq(url)
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