class PractitionersController < ApplicationController
  def autocomplete
    respond_to do |format|
      format.json { create_json_response }
      format.html { redirect_to root_path }
    end
  end

  private
  def create_json_response
    render json: { message: 'hi', phone: 'who' }, status: :ok
  end
end