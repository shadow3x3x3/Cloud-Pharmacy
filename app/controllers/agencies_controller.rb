# Agencies Controller
class AgenciesController < ApplicationController
  before_action :set_agency, only:  [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user &.auth == 'pharmacist'
  end

  def index
    @agencies = Agency.page(params[:page]).per(5)
  end

  def new
    @agency = Agency.new
  end

  def create
    @agency = Agency.new(agency_params)
    if @agency.save
      redirect_to agencies_url
      flash[:notice] = "已成功新增機構資料"
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @agency.update(agency_params)
      redirect_to agencies_url
      flash[:notice] = "已成功更新機構資料"
    else
      render action: :edit
    end
  end

  def destroy
    @agency.destroy
    redirect_to action: :index
    flash[:alert] = "已成功刪除機構資料"
  end

  private

  def set_agency
    @agency = Agency.find(params[:id])
  end

  def agency_params
    params.require(:agency)
          .permit(:name, :abbreviation, :phone, :fax, :pharmacistID,
                  :address, :color, :lastDeliveryDay)
  end
end
