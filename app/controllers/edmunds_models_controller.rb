class EdmundsModelsController < ApplicationController

  def index
    params[:year] ? year = params[:year] : year = 1800
    @edmunds_models = Edmunds.list_of_auto_models(
        params[:make],
        params:{
          api_key:Rails.application.secrets.edmunds_api_key,
          year:year})
    respond_to do |format|
      format.json { render json: @edmunds_models }
    end
  end

end
