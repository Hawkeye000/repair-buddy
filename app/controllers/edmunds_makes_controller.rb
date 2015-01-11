class EdmundsMakesController < ApplicationController

  def index
    params[:year] ? year = params[:year] : year = 1800
    @edmunds_makes = Edmunds.list_of_auto_makes(params:{
      api_key:Rails.application.secrets.edmunds_api_key,
      year:year})
    respond_to do |format|
      format.json { render json: @edmunds_makes }
    end
  end

end
