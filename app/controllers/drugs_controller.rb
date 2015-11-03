class DrugsController < ApplicationController

  before_action :set_drug, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user && admin_only
  end

  def index
    if params[:search]
      @drugs = Drug.where('oriName LIKE ? OR chiName LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @drugs = Drug.page(params[:page]).per(5)
    end

  end

  def new
    @drug = Drug.new
  end

  def create
    @drug = Drug.new(drug_params)
    if @drug.save
      redirect_to drugs_url
      flash[:notice] = "已成功新增藥品資料"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @drug.update(drug_params)
      redirect_to drugs_url
      flash[:notice] = "已成功更新藥品資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @drug.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除藥品資料"
  end

  private

  def set_drug
    @drug = Drug.find(params[:id])
  end

  def drug_params
    params.require(:drug).permit(:oriName, :chiName, :stock, :price, :picture, :isChronic)
  end



end
