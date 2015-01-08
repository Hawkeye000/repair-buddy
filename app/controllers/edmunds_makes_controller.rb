class EdmundsMakesController < ApplicationController
  include Edmunds

  before_filter :check_format

  def index
    render Edmunds.list_of_auto_makes(params:{ api_key:Rails.application.secrets.edmunds_api_key })
  end

  private

    def check_format
      render :nothing => true, :status => 406 unless params[:format] == 'json' || request.headers['Accept'] =~ /json/
    end

end
