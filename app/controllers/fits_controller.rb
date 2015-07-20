class FitsController < ApplicationController

  before_action :set_fit, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user && admin_only
  end

  def index
    @fits = Fit.page(params[:page]).per(5)
  end

  def new
    @fit = Fit.new
  end

  def create
    @fit = Fit.new(fit_params)
    if @fit.save
      redirect_to fits_url
      flash[:notice] = "已成功新增散客資料"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @fit.update(fit_params)
      redirect_to fits_url
      flash[:notice] = "已成功更新散客資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @fit.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除散客資料"
  end

  private

  def set_fit
    @fit = Fit.find(params[:id])
  end

  def fit_params
    params.require(:fit).permit(:fitIdNumber, :name, :phoneOffice, :phoneHome, :cellphone,
                                :address, :birthday)
  end
end
