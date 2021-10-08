class AppliesController < ApplicationController
  
  before_action :authenticate_user!

  def create
    current_user.applies.create(group_id: apply_params[:group_id])
    redirect_to group_path(apply_params[:group_id]), notice: "加入申請しました"
  end

  def destroy
    @apply = Apply.find(params[:apply_id])
    binding.pry
    @apply.destroy
    @group = Group.find(params[:group_id])
    redirect_to group_url(@group), notice: "加入申請を取り消しました"
  end

  def index
    @applies = Apply.where(group_id: params[:group_id])
  end

  private

    def apply_params
      params.permit(:group_id)
    end
end
