class GroupCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    group_comment = current_user.group_comments.new(group_comment_params)
    group_comment.group_id = @group.id
    comment_group = group_comment.group
    if group_comment.save
      # 通知の作成
      comment_group.create_notification_comment!(current_user, group_comment)
    end
    @groupt_comment = GroupComment.new
  end

  def destroy
    @group = Group.find(params[:group_id])
    @group_comment = @group.group_comments.find(params[:id])
    @group_comment.destroy
  end

  private

  def group_comment_params
    params.require(:group_comment).permit(:comment)
  end
end
