class ResidentsController < ApplicationController

  before_action :set_resident, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user && admin_only
  end

  def index
    @residents = Resident.page(params[:page]).per(5)
  end

  def new
    @resident = Resident.new
  end

  def create
    @resident = Resident.new(resident_params)
    if @resident.save
      redirect_to residents_url
      flash[:notice] = "已成功新增住民資料"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @resident.update(resident_params)
      redirect_to residents_url
      flash[:notice] = "已成功更新住民資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @resident.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除住民資料"
  end

  private

  def set_resident
    @resident = Resident.find(params[:id])
  end

  def resident_params
    params.require(:resident).permit(:residentIdNumber, :name, :birthday,
                                     :bedNumber, :liveFloor, :agencyID)
  end

end
