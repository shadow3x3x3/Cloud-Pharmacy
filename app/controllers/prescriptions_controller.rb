class PrescriptionsController < ApplicationController

  before_action :set_prescription, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user && admin_only
  end

  def index
    classification ||= params[:classification]
    case classification
    when nil, "all"
      @prescriptions = Prescription.page(params[:page]).per(5)
    when "fit"
      prescriptionIDs = PrescriptionOfAll.where( :identityCheck => "fit" ).pluck(:prescriptionID)
      @prescriptions = Prescription.find(prescriptionIDs)
      @prescriptions = Kaminari.paginate_array(@prescriptions).page(params[:page]).per(5)
    when "resident"
      prescriptionIDs = PrescriptionOfAll.where( :identityCheck => "resident" ).pluck(:prescriptionID)
      @prescriptions = Prescription.find(prescriptionIDs)
      @prescriptions = Kaminari.paginate_array(@prescriptions).page(params[:page]).per(5)
    end
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
    params.require(:prescription).permit(:days, :deliveryTimes, :doctorDate,
                                         :compoundingTimes, :firstDate, :secondDate,
                                         :personAdded, :lastModifier, :hospitalID,
                                         :phoneStatus, :obtainStatus)
  end

end
