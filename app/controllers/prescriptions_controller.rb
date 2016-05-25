# Prescriptions Controller
class PrescriptionsController < ApplicationController
  before_action :set_prescription, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    page = params[:page]
    classification ||= params[:classification]
    @prescriptions = auth_check(current_user, classification, page)
  end

  def new
    redirect_to root_path unless current_user &.auth == 'customer'
    @prescription = Prescription.new
  end

  def create
    @prescription = Prescription.new(prescription_params)
    @prescription.owner = 'fit' if current_user.auth == 'customer'
    @prescription.owner = 'resident' if current_user.auth == 'nurse'
    @prescription.ownerID = params["prescription"]["ownerID"]
    if @prescription.save
      redirect_to prescriptions_url
      flash[:notice] = "已成功處方箋資料"
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @prescription.update(prescription_params)
      redirect_to prescriptions_url
      flash[:notice] = "已成功更新處方箋資料"
    else
      render action: :edit
    end
  end

  def show
    @prescription = Prescription.find(params[:id])
    @delivery     = @prescription.delivery
  end

  def destroy
    @prescription.destroy
    redirect_to action: :index
    flash[:alert] = "已成功刪除處方箋資料"
  end

  def deal
    @prescription = Prescription.find(params[:id])
    obtain_status = { obtainStatus: true } if @prescription.obtainStatus == false
    obtain_status = { obtainStatus: false } if @prescription.obtainStatus == true
    if @prescription.update(obtain_status)
      redirect_to prescriptions_url
      flash[:notice] = "已成功處理處方箋資料"
    else
      redirect_to prescriptions_url
    end
  end

  private

  def auth_check(current_user, classification, page)
    case current_user.auth
    when 'pharmacist'
      classification_action(classification, page)
    when 'nurse'
      agency_prescription(current_user, page)
    when 'customer'
      customer_prescription(current_user, page)
    end
  end

  def classification_action(classification, page_num)
    case classification
    when nil, 'all'
      Prescription.page(page_num).per(10)
    when 'fit'
      kaminari_array(fits_prescription, page_num)
    when 'resident'
      kaminari_array(residents_prescription, page_num)
    when 'undeal'
      kaminari_array(undeal_prescription, page_num)
    end

  end

  def kaminari_array(array, page_num)
    Kaminari.paginate_array(array).page(page_num).per(10)
  end

  def fits_prescription
    Prescription.where(owner: 'fit')
  end

  def residents_prescription
    Prescription.where(owner: 'resident')
  end

  def undeal_prescription
    Prescription.where(obtainStatus: false)
  end

  def agency_prescription(current_user, page_num)
    agency_id = Agency.where(name: current_user.name)
    prescriptions = Prescription.where(owner: 'resident', ownerID: agency_id)
    kaminari_array(prescriptions, page_num)
  end

  def customer_prescription(current_user, page_num)
    fitID = Fit.where(memberID: current_user.id)
    prescriptions = Prescription.where(owner: 'fit', ownerID: fitID)
    kaminari_array(prescriptions, page_num)
  end

  def set_prescription
    @prescription = Prescription.find(params[:id])
  end

  def prescription_params
    params.require(:prescription)
          .permit(:days, :deliveryTimes, :doctorDate,
                  :compoundingTimes, :firstDate, :secondDate,
                  :personAdded, :lastModifier, :hospitalID,
                  :phoneStatus, :obtainStatus, :image,
                  delivery_attributes: [
                    :contactPerson, :contactPhone, :address,
                    :quantity, :date, :session, :paharmacistID,
                    :prescriptionsID, :_destory])
  end
end
