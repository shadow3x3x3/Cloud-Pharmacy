class AssessmentFormsController < ApplicationController

  before_action :set_assessmentForm, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user &.auth != "customer"
  end

  Result_array = [
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
  ]

  def index
    if current_user.auth == "nurse"
      agencyID = Agency.find_by_name(current_user.name).id
      residents = Resident.where(:agencyID => agencyID).pluck(:residentID)
      @assessmentForms = AssessmentForm.where(:residentID => residents)
      @assessmentForms = @assessmentForms.page(params[:page]).per(5)
    else
      @assessmentForms = AssessmentForm.page(params[:page]).per(5)
    end
  end

  def new
    @assessmentForm = AssessmentForm.new
    @result_array   = Result_array
  end

  def create
    if current_user.auth == "pharmacist"
      @result = params[:assessmentResult_ids].join(",") unless params[:assessmentResult_ids].nil?
      params[:assessment_form]["af_pharmacist_assess_attributes"]["assessmentResult"] = @result unless @result.nil?
    end
    @assessmentForm = AssessmentForm.new(assessmentForm_params)
    af_pharmacist_assess = AfPharmacistAssess.new
    if @assessmentForm.save
      af_pharmacist_assess = AfPharmacistAssess.new( :pharmacistAssessID => @assessmentForm.afID)
      af_pharmacist_assess.save
      pdf = AfPdf.new(@assessmentForm, view_context)
      pdf.render_file "app/assets/assessmentPDF/#{params[:id]}.pdf"
      redirect_to assessment_forms_url
      flash[:notice] = "已成功新增評估記錄表"
    else
      render :action => :new
    end
  end

  def edit
    @assessmentForm  = AssessmentForm.find(params[:id])
    assessmentResult = AfPharmacistAssess.find(@assessmentForm.afID).assessmentResult.to_s

    # 傳入結果
    @assessmentResult_ids = assessmentResult.split(",")
    @result_array         = Result_array

  end

  # show PDF here
  def show
    @assessmentForm = AssessmentForm.find(params[:id])
    path = Rails.root + "app/assets/assessmentPDF/#{params[:id].to_i}.pdf"

    if File.exist?(path)
      send_file(path,
      :disposition => 'inline',
      :type => 'application/pdf',
      :x_sendfile => true)
    else
      df = AfPdf.new(@assessmentForm, view_context)
      pdf.render_file "app/assets/assessmentPDF/#{params[:id]}.pdf"
    end
  end

  def update
    if current_user.auth == "pharmacist"
      @assessmentForm = AssessmentForm.find(params[:id])
      @result         = params[:assessmentResult_ids].join(",")

      params[:assessment_form]["af_pharmacist_assess_attributes"]["assessmentResult"] = @result

    end

    if @assessmentForm.update_attributes(assessmentForm_params)
      pdf = AfPdf.new(@assessmentForm, view_context)
      pdf.render_file "app/assets/assessmentPDF/#{params[:id]}.pdf"
      redirect_to assessment_forms_url
      flash[:notice] = "已成功更新評估記錄表"
    else
      render :action => :edit
    end
  end


  def destroy
    @assessmentForm = AssessmentForm.find(params[:id])
    @assessmentForm.destroy
    redirect_to :action => :index
    flash[:alert] = "已成功刪除評估記錄表"
  end

  private

  def set_assessmentForm
    @assessmentForm = AssessmentForm.find(params[:id])
  end

  def assessmentForm_params
    params.require(:assessment_form).permit(
      :afDruguse, :afLiverFunction, :afKidneyFunction, :residentID, :id,
      :allergyFood, :allergyDrug, :referenceAccessories, :prescriptionContentID,
      :pharmacistAssessID, :nurseHandlingID, :status,
      :af_prescription_content_attributes => [:id,
                                              :hospitalName1, :division1, :doctorDate1, :days1, :remark1,
                                              :hospitalName2, :division2, :doctorDate2, :days2, :remark2,
                                              :hospitalName3, :division3, :doctorDate3, :days3, :remark3
                                             ],
      :af_pharmacist_assess_attributes    => [ :id,
                                               :assessmentResult, :suggestion, :referenceData, :referenceBooks
                                             ],
      :af_nurse_handling_attributes       => [ :id,
                                              :mode, :doctorDo, :residentFollow
                                             ])

  end

end
