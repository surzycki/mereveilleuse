unless Rails.env.test?
  Experiments.setup(ENV['GOOGLE_EXPERIMENT_ID'])
end