# Setup global listeners
unless Rails.env.test?
  Wisper.subscribe(SlackNotifierListener.new)
end