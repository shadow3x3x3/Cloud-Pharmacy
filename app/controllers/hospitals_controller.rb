class HospitalsController < ApplicationController

  before_action :set_hospital, :only => [ :edit, :update, :destroy]

  def index
    @hospitals = Hospital.page(params[:page]).per(5)
  end

  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = Hospital.new(hospital_params)
    if @hospital.save
      redirect_to hospitals_url
      flash[:notice] = "已成功新增醫院資料"
    else
      render :action => :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @hospital.update(hospital_params)
      redirect_to hospitals_url
      flash[:notice] = "已成功更新醫院資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @hospital.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除資料"
  end

  private

  def set_hospital
    @hospital = Hospital.find(params[:id])
  end

  def hospital_params
    params.require(:hospital).permit(:name, :address, :isDrugID)
  end
end
