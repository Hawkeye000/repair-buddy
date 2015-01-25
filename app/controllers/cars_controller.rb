class CarsController < ApplicationController

  def show
  end

  def index
    if current_user
      @cars = Car.where(user_id:current_user.id)
      @user = current_user
    else
      redirect_to new_user_session_path
    end
  end

  def new
    if current_user
      @car = Car.new
      @user = current_user
    else
      redirect_to new_user_session_path
    end
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    if current_user
      Car.find(params[:id]).destroy
      redirect_to user_cars_path
    else
      redirect_to root_path
    end
  end

  private

    def car_params
      params.require(:car).permit(:user_id, :make, :model, :year, :trim, :edmunds_id)
    end

end
