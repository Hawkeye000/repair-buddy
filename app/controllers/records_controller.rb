class RecordsController < ApplicationController

  before_filter :set_record, only:[:show, :edit, :destroy, :update]
  before_filter :check_user_for_index, only:[:index]
  before_filter :set_car, only:[:show, :index]

  def show
  end

  def index
    if params[:car_id]
      @records = Record.where(user_id:params[:user_id], car_id:params[:car_id])
    else
      @records = Record.joins(:car).where(user_id:params[:user_id])
    end
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    if @record.save
      redirect_to user_car_record_path(@record.user_id, @record.car_id, @record.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @record.update(record_params)
      redirect_to user_car_record_path(@record.user_id, @record.car_id, @record.id)
    else
      render :edit
    end
  end

  def destroy
    if @record.destroy
      redirect_to user_car_records_path(@record.user_id, @record.car_id)
    else
      render :index
    end
  end

  private

    def set_record
      @record = Record.find(params[:id])
    end

    def set_car
      @car = Car.find(params[:car_id]) unless params[:car_id].nil?
    end

    def check_user_for_index
      new_path =
        if !current_user
          new_user_session_path
        elsif current_user.id != params[:user_id].to_i
          root_path unless current_user.id == params[:user_id].to_i
        end
      redirect_to new_path, flash:{alert:"You are not authorized to view this user's records."} if new_path
    end


    def record_params
      params.require(:record).permit(:record_type, :car_id, :user_id, :mileage, :short_title, :description, :cost, :date)
    end

end
