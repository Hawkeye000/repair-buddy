class EdmundsVinsController < ApplicationController

  def show
    @edmunds_vin = Edmunds.car_lookup_by_vin(params[:vin],
        params:{ api_key:Rails.application.secrets.edmunds_api_key})
    respond_to do |format|
      format.json { render json:@edmunds_vin }
    end
  end

end
