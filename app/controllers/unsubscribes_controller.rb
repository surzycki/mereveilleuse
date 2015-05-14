class UnsubscribesController < ApplicationController
  before_filter :token_authentication!
  around_filter :catch_exceptions, unless: 'Rails.env.development?'
  
  # GET unsubscribe/search/:token/:id
  def search
    unsubscribe_service.on :unsubscribe_search_success do |search|
      render :search
    end

    unsubscribe_service.on :unsubscribe_search_fail do |message|
      flash.now[:alert] = message
      redirect_to not_found_path
    end

    unsubscribe_service.unsubscribe_search current_search
  end

  # GET unsubscribe/account/:token
  def account
    unsubscribe_service.on :unsubscribe_account_success do |user|
      render :account
    end

    unsubscribe_service.on :unsubscribe_account_fail do |message|
      flash.now[:alert] = message
      redirect_to not_found_path
    end

    unsubscribe_service.unsubscribe_account current_user
  end

  private
  def unsubscribe_service
    @unsubscribe_service ||= UnsubscribeService.new
  end

  def current_search
    @search ||= Search.find_by(id: params[:id])
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end