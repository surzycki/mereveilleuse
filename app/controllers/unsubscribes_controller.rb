class UnsubscribesController < ApplicationController
  around_filter :catch_exceptions, unless: 'Rails.env.development?'
  
  # GET unsubscribe/search/:id
  def search
    if load_search
      @search.canceled!
    else
      redirect_to not_found_path
    end
  end

  # GET unsubscribe/account/:id
  def account
    if load_user
      @user.unsubscribe
    else
      redirect_to not_found_path
    end
  end

  private
  def load_search
    @search ||= Search.find_by(md5_hash: params[:id])
  end

  def load_user
    @user ||= User.find_by(facebook_id: params[:id])
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, logger )
    redirect_to not_found_path
  end
end