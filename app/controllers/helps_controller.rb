class HelpsController < ApplicationController
  around_action :catch_exceptions, unless: 'Rails.env.development?'

  def new
    @form = HelpForm.new
  end

  def create
    @form = HelpForm.new(help_params)
    
    if @form.process
      HelpMailer.customer_service(
        @form.email, @form.help_topic, @form.message
      ).deliver_now

      redirect_to new_help_path, notice: 'Merci'
    else
      flash.now[:alert] = @form.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
  end

  private
  def help_params
    params.require(:help_form)
      .permit(:email, :help_topic, :message)
  end

  def catch_exceptions
    yield
  rescue => error  
    TrackError.new( error, env )
    redirect_to not_found_path
  end
end