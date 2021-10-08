class GroupsController < ApplicationController

  before_action :authenticate_user!, except: [:index]
  before_action :ensure_admin_user, only: [:edit, :update] #主催者以外はedit,updateできなくする

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
    @apply = Apply.find_by(group_id: @group.id, user_id: current_user.id)
    @group_news = GroupNew.where(group_id: @group.id)
    @group_comment = GroupComment.new
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

  #参加申請を許可すると、GroupUserレコードを生成し、該当のapplyレコードを削除する
  def join
    @group = Group.find(params[:group_id])
    @apply = Apply.find_by(params[:group_id], params[:user_id])
    @group.users << User.find(params[:user_id])
    @apply.destroy!
    flash[:notice] = '参加を承認しました。'
    redirect_to  group_path(@group)
  end

  #参加申請を却下すると、該当のapplyレコードを削除する
  def leave
    @apply = Apply.find_by(params[:group_id], params[:user_id])
    @apply.destroy!
    flash[:notice] = '申請を却下しました。。'
    redirect_to groups_path
  end

  private

    def group_params
      params.require(:group).permit(:name, :introduction, :group_image)
    end

    def ensure_admin_user
      @group = Group.find(params[:id])
      unless @group.admin_user_id == current_user.id
        redirect_to group_path(@group)
      end
    end
end
