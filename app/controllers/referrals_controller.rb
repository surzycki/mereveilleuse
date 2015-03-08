class ReferralsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :index

  def index
    i = 10
  end 
end
