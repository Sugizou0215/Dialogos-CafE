class GroupCommentsController < ApplicationController

  before_action :authenticate_user!

  def create
    group = Group.find(params[:group_id])
    comment = current_user.group_comments.new(group_comment_params)
    comment.group_id = group.id
    comment.save
    redirect_to group_path(group)
  end

  def destroy
    @group = Group.find(params[:group_id])
    group_comment = @group.group_comments.find(params[:id])
    group_comment.destroy
    redirect_to group_path(params[:group_id])
  end

  private

    def group_comment_params
      params.require(:group_comment).permit(:comment)
    end
end
