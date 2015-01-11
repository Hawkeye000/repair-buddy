class EdmundsMakesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        params[:year] ? year = params[:year] : year = 1800
        render json: Edmunds.list_of_auto_makes(params:{
            api_key:Rails.application.secrets.edmunds_api_key,
            year:year})
      end
    end
  end

end
