class MembersController < ApplicationController

  before_action :set_member, :only => [ :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user &.auth == "pharmacist"
  end

  def index
    @members = Member.page(params[:page]).per(5)
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to members_url
      flash[:notice] = "已成功新增會員資料"
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to members_url
      flash[:notice] = "已成功更新會員資料"
    else
      render :action => :edit
    end
  end

  def destroy

    @member.destroy

    redirect_to :action => :index
    flash[:alert] = "已成功刪除會員資料"
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:memberIdNumber, :email, :name, :phone)
  end
end
