module IntegrationHelpers
  def screenshot
    page.save_screenshot('public/screenshot.png', full: true)
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def translate_model(value)
    value.singularize.capitalize.constantize
  end

  def underscoreize(value)
    value.split(' ').join('_')
  end
end

RSpec.configure do |config| 
  config.include IntegrationHelpers
end