class UnsubscribesController < ApplicationController
  before_filter :token_authentication!
  around_filter :catch_exceptions, unless: 'Rails.env.development?'
  
  # GET unsubscribe/search/:token/:id
  def search
    if load_search
      @search.canceled!
    else
      redirect_to not_found_path
    end
  end

  # GET unsubscribe/account/:token
  def account
    if current_user
      current_user.unsubscribe
    else
      redirect_to not_found_path
    end
  end

  private
  def load_search
    @search ||= Search.find_by(id: params[:id])
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end