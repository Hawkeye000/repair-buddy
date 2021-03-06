class CarsController < ApplicationController

  def show
  end

  def index
    @user = User.find(params[:user_id])
    if @user == current_user
      @cars = Car.where(user:@user)
    elsif current_user
      redirect_to user_cars_path(current_user.id)
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
    authorize @car
    if @car.save
      redirect_to user_cars_path(@car.user.id)
    else
      render :new
    end
  end

  def destroy
    @car = Car.find(params[:id])
    authorize @car
    if @car.destroy
      redirect_to user_cars_path unless request.xhr?
    else
      redirect_to root_path unless request.xhr?
    end
  end

  private

    def car_params
      params.require(:car).permit(:user_id, :make, :model, :year, :trim, :edmunds_id)
    end

end
