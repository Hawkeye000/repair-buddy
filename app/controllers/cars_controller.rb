class CarsController < ApplicationController

  def new
    if current_user
      @car = Car.new
    else
      redirect_to new_user_session_path
    end
  end

  def show
  end

end
