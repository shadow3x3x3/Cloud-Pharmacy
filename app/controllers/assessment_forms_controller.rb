class AssessmentFormsController < ApplicationController

  before_action :set_assessmentForm, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user && admin_only
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
    "重複同藥理作用或成分",
    "醫師處方過敏性藥物",
    "不符合健保使用規範",

    "需注意臨床症狀",
    "劑型劑量或頻率需調整",
    "有該使用而未併用藥物",
    "其他"
  ]

  def index
    @assessmentForms = AssessmentForm.page(params[:page]).per(5)
  end

  def new
    @assessmentForm = AssessmentForm.new
  end

  def create
    @assessmentForm = AssessmentForm.new(assessmentForm_params)
    if @assessmentForm.save
      redirect_to assessment_forms_url
      flash[:notice] = "已成功新增評估記錄表"
    else
      render :action => :new
    end
  end

  def edit
    @assessmentForm  = AssessmentForm.find(params[:id])
    assessmentResult = AfPharmacistAssess.find(@assessmentForm.pharmacistAssessID).assessmentResult.to_s

    # 傳入結果
    @assessmentResult_ids = assessmentResult.split(",")
    @result_array         = Result_array

  end

  # show PDF here
  def show
    @assessmentForm = AssessmentForm.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = AfPdf.new(@assessmentForm, view_context)
        send_data pdf.render, filename: "af.pdf",
        type: "application/pdf", disposition: "inline",
        pagesize: "A4"
      end
    end

  end

  def update
    @assessmentForm     = AssessmentForm.find(params[:id])
    @afPharmacistAssess = AfPharmacistAssess.find(@assessmentForm.pharmacistAssessID)

    @result = params[:assessmentResult_ids].join(",")

    @afPharmacistAssess.assessmentResult = @result
    @assessmentForm.pharmacistAssessID   = @afPharmacistAssess.pharmacistAssessID

    if @assessmentForm.update(assessmentForm_params)
      redirect_to assessment_forms_url
      flash[:notice] = "已成功更新評估記錄表"
    else
      render :action => :edit
    end
  end


  def destroy
    @assessmentForm.destroy
    redirect_to :action => :index
    flash[:alert] = "已成功刪除評估記錄表"
  end

  private

  def set_assessmentForm
    @assessmentForm = AssessmentForm.find(params[:id])
  end

  def assessmentForm_params
    params.require(:assessmentForm).permit(
      :afDruguse, :afLiverFunction, :afKidneyFunction,
      :allergyFood, :allergyDrug, :referenceAccessories, :prescriptionContentID,
      :pharmacistAssessID, :nurseHandlingID)
  end

end
