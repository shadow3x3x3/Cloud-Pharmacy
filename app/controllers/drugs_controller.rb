class DrugsController < ApplicationController

  before_action :set_drug, :only => [ :edit, :update, :destroy]

  def index
    @drugs = Drug.page(params[:page]).per(5)
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
