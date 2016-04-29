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
    @prescription = Prescription.new
  end

  def create
    @prescription = Prescription.new(prescription_params)
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
    @prescription_of_drugs =
      PrescriptionOfDrug.where(prescriptionID: params[:id])
  end

  def destroy
    @prescription.destroy
    redirect_to action: :index
    flash[:alert] = "已成功刪除醫院資料"
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
      Prescription.page(page_num).per(5)
    when 'fit'
      kaminari_array(fits_prescription, page_num)
    when 'resident'
      kaminari_array(residents_prescription, page_num)
    end
  end

  def kaminari_array(array, page_num)
    Kaminari.paginate_array(array).page(page_num).per(5)
  end

  def fits_prescription
    prescription_ids =
      PrescriptionOfAll.where(identityCheck: 'fit').pluck(:prescriptionID)
    Prescription.find(prescription_ids)
  end

  def residents_prescription
    prescription_ids =
      PrescriptionOfAll.where(identityCheck: 'resident').pluck(:prescriptionID)
    Prescription.find(prescription_ids)
  end

  def agency_prescription(current_user, page_num)
    agency_id = Agency.find_by_name(current_user.name).id
    residents = Resident.where(agencyID: agency_id).pluck(:residentID)
    prescription_of_resident_id =
      PrescriptionOfAll.where(identityCheck: 'resident')
                       .pluck(:prescriptionID)
    rescription_ids = prescription_of_resident_id & residents
    prescriptions = Prescription.find(rescription_ids)
    kaminari_array(prescriptions, page_num)
  end

  def customer_prescription(current_user, page_num)
    rescription_ids =
      PrescriptionOfAll.where(userID: current_user.id, identityCheck: 'fit')
                       .pluck(:prescriptionID)

    prescriptions = Prescription.find(rescription_ids)
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
                  :phoneStatus, :obtainStatus)
  end
end
