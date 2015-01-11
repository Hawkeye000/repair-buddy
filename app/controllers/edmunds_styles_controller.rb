class EdmundsStylesController < ApplicationController

  def index
    @edmunds_models = Edmunds.list_of_auto_styles(
        params[:make], params[:model], params[:year],
        params:{ api_key:Rails.application.secrets.edmunds_api_key})
    respond_to do |format|
      format.json { render json: @edmunds_models }
    end
  end

end
