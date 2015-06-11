class SqueezesController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'

  layout 'application_only_footer'

  def index
    if params[:id]
      detailed_page 
    else
      general_page
    end
  end

  def create
  
    email   = squeeze_params[:email] || 'none'
    message = "#{squeeze_params[:name]} #{squeeze_params[:phone]} #{squeeze_params[:time]}"

    HelpMailer.customer_service(
      email, 'Squeeze Page', message
    ).deliver_now

    redirect_to squeeze_thanks_path
  end

  def show
    render layout: 'application_blank'
  end

  private
  def detailed_page
    @experiment = Experiments.new(
      id: ENV['GOOGLE_EXPERIMENT_ID'],
      user_id: cookies['_session_id']
    )
    
    render "variation_#{@experiment.variation}"
  end

  def general_page
    render 'variation_2'
  end

  private
  def squeeze_params
    params.require(:squeeze_form).permit(:name, :phone, :time, :email )
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error )
    
    redirect_to internal_server_error_path
  end
end
