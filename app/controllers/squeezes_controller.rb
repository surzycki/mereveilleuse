class SqueezesController < ApplicationController
  around_filter :catch_exceptions, unless: 'Rails.env.development?'

  layout 'application_only_footer'

  def index
    @experiment = Experiments.new(
      id:  'S2Il9_TBT_aL0i8SzdTcsw',
      user_id: cookies['_session_id']
    )
    
    #render 'variation_0'
    render "variation_#{@experiment.variation}"
  end

  private
  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error )
    
    redirect_to internal_server_error_path
  end
end
