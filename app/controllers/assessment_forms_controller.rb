class AssessmentFormsController < ApplicationController

  before_action :set_assessmentForm, :only => [ :edit, :update, :destroy]

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
  end

  # show PDF here
  def show
  end

  def update
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
    params.require(:assessmentForm).permit(:name, :address, :isDrugID)
  end

end
