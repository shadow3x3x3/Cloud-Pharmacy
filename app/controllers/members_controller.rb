class MembersController < ApplicationController

  before_action :set_member, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user &.auth == "pharmacist" || "customer"
  end

  def index
    redirect_to root_path unless current_user &.auth == "pharmacist"
    @members = Member.page(params[:page]).per(5)
  end

  def all_fits
    @fits = current_user.member.fits
  end

  def add_fit
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:memberIdNumber, :email, :name, :phone)
  end
end
