class HospitalsController < ApplicationController
  def index
    @hospitals = Hospital.all
  end

  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = Hospital.new(hospital_params)
    @hospital.save

    redirect_to :action => :index
  end

  private

  def hospital_params
    params.require(:hospital).permit(:name, :address, :isDrugID)
  end
end
