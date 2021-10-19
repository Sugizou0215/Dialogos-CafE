class GroupNewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def new
    @group_new = GroupNew.new
  end

  def create
    @group_new = GroupNew.new(group_new_params)
    @group_new.group_id = params[:group_id]
    @group = Group.find(params[:group_id])
    @group_users = GroupUser.where(group_id: params[:group_id]).pluck(:user_id)
    @users = User.where(id: @group_users)
    if @group_new.save
      redirect_to group_path(@group_new.group_id), notice: 'お知らせを投稿しました'
      @group.create_notification_news!(@users, @group) # models/user.rb参照：グループ参加申請と同時に通知作成
    else
      render :new
    end
  end

  def edit
    @group_new = GroupNew.find(params[:id])
  end

  def update
    if @group_new = GroupNew.update(group_new_params)
      redirect_to group_path(params[:group_id]), notice: 'お知らせを編集しました'
    else
      render 'edit'
    end
  end

  def destroy
    @group_new = GroupNew.find(params[:id])
    @group_new.destroy
    redirect_to group_path(params[:group_id]), notice: 'お知らせを編集しました'
  end

  private

  def group_new_params
    params.require(:group_new).permit(:title, :body)
  end
end
