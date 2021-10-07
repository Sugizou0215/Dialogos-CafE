class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.admin_user_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path, notice: 'グループ作成に成功しました'
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @admin_user = User.find(@group.admin_user_id)
  end

  def index
    @groups = Group.all
    @user = current_user #ユーザー情報表示用（サイドバー）
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group = Group.update(group_params)
      redirect_to group_path(@group), notice: "正常にイベント情報が変更されました。"
    else
      render "edit"
    end
  end

  private

    def group_params
      params.require(:group).permit(:name, :introduction, :group_image)
    end
end
