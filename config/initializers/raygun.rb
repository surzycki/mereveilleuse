Raygun.setup do |config|
  config.api_key = "xH3UHjQjvM5Y7dxgItSs1Q=="
  config.filter_parameters = Rails.application.config.filter_parameters

  # The default is Rails.env.production?
  config.enable_reporting = Rails.env.staging? || Rails.env.production?
end
