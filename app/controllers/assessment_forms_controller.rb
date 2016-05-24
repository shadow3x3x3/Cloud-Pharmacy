class AssessmentFormsController < ApplicationController

  before_action :set_assessment_form, only: [ :edit, :update, :destroy]
  before_action :put_results, only: [ :new, :edit ]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user &.auth != 'customer'
  end

  RESULTS = [
    "無特殊情形",
    "禁忌症或注意事項",
    "藥物不良反應",
    "服藥順從性不佳",

    "需藥物衛教或用藥資訊",
    "需監測藥物血中濃度",
    "不適當藥物治療處方",
    "有疾病未治療",

    "藥物交互作用",
    "重複同藥理作用或成份",
    "醫師處方過敏性藥物",
    "不符合健保使用規範",

    "需注意臨床症狀",
    "劑型劑量或頻率需調整",
    "有該使用而未併用藥物",
    "其他"
  ].freeze

  def index
    if current_user.auth == 'nurse'
      @assessment_forms = current_user.nurse_af
      @assessment_forms = @assessment_forms.page(params[:page]).per(5)
    else
      @assessment_forms = AssessmentForm.page(params[:page]).per(5)
    end
  end

  def new
    @assessment_form = AssessmentForm.new
  end

  def create
    if current_user.auth == 'pharmacist'
      @result = params[:assessment_results_ids].join(',') unless params[:assessment_results_ids].nil?
      params[:assessment_form]['af_pharmacist_assess_attributes']['assessmentResult'] = @result unless @result.nil?
    end
    @assessment_form = AssessmentForm.new(assessment_form_params)
    #  = AfPharmacistAssess.new
    if @assessment_form.save
      af_pharmacist_assess = AfPharmacistAssess.new(pharmacistAssessID: @assessment_form.afID)
      af_pharmacist_assess.save
      pdf = AfPdf.new(@assessment_form, view_context)
      pdf.render_file "app/assets/assessmentPDF/#{params[:id]}.pdf"
      redirect_to assessment_forms_url
      flash[:notice] = "已成功新增評估記錄表"
    else
      render action: :new
    end
  end

  def edit
    @assessment_form = AssessmentForm.find(params[:id])
    assessment_results = AfPharmacistAssess.find(@assessment_form.afID).assessmentResult.to_s

    @assessment_results_ids = assessment_results.split(',')
  end

  # show PDF here
  def show
    @assessment_form = AssessmentForm.find(params[:id])
    path = Rails.root + "app/assets/assessmentPDF/#{params[:id].to_i}.pdf"

    unless File.exist?(path)
      pdf = AfPdf.new(@assessment_form, view_context)
      pdf.render_file path
    end
    send_file(path, disposition: 'inline',
                    type: 'application/pdf',
                    x_sendfile: true)
  end

  def update
    if current_user.auth == 'pharmacist'
      @assessment_form = AssessmentForm.find(params[:id])
      results = params[:assessment_results_ids].join(',')

      params[:assessment_form]['af_pharmacist_assess_attributes']['assessmentResult'] = results
    end

    if @assessment_form.update_attributes(assessment_form_params)
      pdf = AfPdf.new(@assessment_form, view_context)
      pdf.render_file "app/assets/assessmentPDF/#{params[:id]}.pdf"
      redirect_to assessment_forms_url
      flash[:notice] = "已成功更新評估記錄表"
    else
      render action: :edit
    end
  end

  def destroy
    @assessment_form = AssessmentForm.find(params[:id])
    @assessment_form.destroy
    redirect_to action: :index
    flash[:alert] = "已成功刪除評估記錄表"
  end

  private

  def set_assessment_form
    @assessment_form = AssessmentForm.find(params[:id])
  end

  def put_results
    @result_array = RESULTS
  end

  def assessment_form_params
    params.require(:assessment_form).permit(
      :afDruguse, :afLiverFunction, :afKidneyFunction, :residentID, :id,
      :allergyFood, :allergyDrug, :referenceAccessories, :prescriptionContentID,
      :pharmacistAssessID, :nurseHandlingID, :status,
      af_prescription_content_attributes:
      [:id, :hospitalName1, :division1, :doctorDate1, :days1, :remark1,
       :hospitalName2, :division2, :doctorDate2, :days2, :remark2,
       :hospitalName3, :division3, :doctorDate3, :days3, :remark3],
      af_pharmacist_assess_attributes:
      [:id, :assessmentResult, :suggestion, :referenceData, :referenceBooks],
      af_nurse_handling_attributes:
      [:id, :mode, :doctorDo, :residentFollow])
  end
end
