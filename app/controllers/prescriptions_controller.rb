class PrescriptionsController < ApplicationController

  before_action :set_prescription, :only => [ :edit, :update, :destroy]

  def index
    @prescriptions = Prescription.page(params[:page]).per(5)
  end

  def new
    @prescription = Prescription.new
  end

  def create
    @prescription = Prescription.new(prescription_params)
    if @prescription.save
      redirect_to prescriptions_url
      flash[:notice] = "已成功新增醫院資料"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @prescription.update(prescription_params)
      redirect_to prescriptions_url
      flash[:notice] = "已成功更新醫院資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @prescription.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除醫院資料"
  end

  private

  def set_prescription
    @prescription = Prescription.find(params[:id])
  end

  def prescription_params
    params.require(:prescription).permit(:name, :address, :isDrugID)
  end

end
