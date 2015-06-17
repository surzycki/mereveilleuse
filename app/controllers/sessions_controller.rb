class SessionsController < ApplicationController
  #around_action      :catch_exceptions, unless: 'Rails.env.development?'
  #before_action      :initialize_authentication_service, only: [:create]
  #
  ## POST /session
  #def create 
  #  authentication_service.authenticate facebook_authentication
  #end
#
  #def fail
  #  redirect_to new_registration_path
  #end
#
  #private
  #def initialize_authentication_service
  #  authentication_service.on :login do |account, redirect_path|
  #    # set user_id in env for the authentication since we
  #    # aren't passing these during a via params in a post for warden
  #    warden.set_user account, scope: :user
  #    redirect_to(redirect_path || new_search_path)
  #  end
#
  #  authentication_service.on :signup do |account|
  #    # set user_id in env for the authentication since we
  #    # aren't passing these during a via params in a post for warden
  #    warden.set_user account, scope: :user
  #    
  #    redirect_to new_recommendation_path
  #  end
#
  #  # display facebook authentication dialog
  #  authentication_service.on :request_authentication do |auth|
  #    redirect_to new_recommendation_path(requesting_authentication: true) 
  #  end
#
#
  #  authentication_service.on :fail do |error|
  #    TrackError.new( error, env ) if error
  #    redirect_to not_found_path
  #  end
  #end
#
  ## Facebook saves a cookie with a signed request that can be parsed
  ## Facebook canvas apps post a signed_request that which we can use to 
  ## determine the platform
  #def facebook_authentication
  #  @facebook_authentication ||= FacebookAuthentication.new(
  #    cookies: cookies,
  #    app_data: params[:app_data],
  #    signed_request: params[:signed_request]
  #  )
  #end
#
  #def authentication_service
  #  @authentication_service ||= AuthenticationService.new 
  #end
#
  #def catch_exceptions
  #  yield
  #rescue => error  
  #  TrackError.new( error, env )
  #  redirect_to not_found_path
  #end
end
