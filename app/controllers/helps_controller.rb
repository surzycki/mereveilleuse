class HelpsController < ApplicationController
  def new
    @form = HelpForm.new
  end

  def create
    redirect_to help_path, notice: 'Thanks'
  end

  def show
  end
end