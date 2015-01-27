class RecordsController < ApplicationController

  before_filter :set_record, only:[:show, :edit, :destroy, :update]

  def show
  end

  def index
    @records = Record.where(user_id:params[:user_id], car_id:params[:car_id])
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

    def record_params
      params.require(:record).permit(:record_type, :car_id, :user_id, :mileage)
    end

end
