class IdentitiesController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'
  
  # GET /auth/:provider/callback
  def create
    
    @form = RegistrationForm.new registration_params
  
    registration_service.on :user_created do |user, registration_type|
      # has user signed up by recommending or by inviting
      if registration_type == 'recommendation'
        user.recommendations << recommendation
      else
        user.update(has_invited: true)
      end

      # authenticate user
      warden.set_user user, scope: :user
      # redirect to search
      redirect_to new_search_path
    end

    registration_service.on :user_create_fail do |errors|
      redirect_to auth_failure_path
    end

    registration_service.register registration_type
  end

  # GET /auth/failure
  def failure  
    # Facebook permissions denied
    if error_code >= 200 && error_code <= 299 
      render :failure
    else  
      redirect_to root_path
    end
  end

  private
  def registration_params
    request.env['omniauth.auth']
  end

  def registration_type
    request.env['omniauth.params']['type']
  end

  def registration_service
    @registration_service ||= RegistrationService.new(@form)
  end

  def recommendation
    Recommendation.find_by(id: session[:recommendation_id])
  end

  def error_code
    params[:error_code].to_i
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end