class SearchMailer < ApplicationMailer
  def results
    mail(to: 'bob@test.com', subject: 'Welcome to My Awesome Site')
  end
end
