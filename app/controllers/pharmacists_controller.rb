class PharmacistsController < ApplicationController

  before_action :set_pharmacist, :only => [ :edit, :update, :destroy]

  def index
    @pharmacists = Pharmacist.page(params[:page]).per(5)
  end

  def new
    @pharmacist = Pharmacist.new
  end

  def create
    @pharmacist = Pharmacist.new(pharmacist_params)
    if @pharmacist.save
      redirect_to pharmacists_url
      flash[:notice] = "已成功新增藥師資料"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @pharmacist.update(pharmacist_params)
      redirect_to pharmacists_url
      flash[:notice] = "已成功更新藥師資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @pharmacist.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除資料"
  end

  private

  def set_pharmacist
    @pharmacist = Pharmacist.find(params[:id])
  end

  def pharmacist_params
    params.require(:pharmacist).permit(:name, :salary, :deliveryTimes, :remark)
  end

end
