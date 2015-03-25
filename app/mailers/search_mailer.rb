class SearchMailer < ApplicationMailer
  def results(search, results)
    # don't send if no results
    return if results.empty?
  
    mail(to: 'bob@test.com', subject: 'Welcome to My Awesome Site')
  end
end
