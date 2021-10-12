class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    #汚いので後でメソッドを切り離すこと
    #参加前・参加済みのイベントを抽出（EventUserテーブルから検索）
    @user_events = EventUser.where(user_id: @user.id).pluck(:event_id).uniq
    @join_events = Event.where(id: @user_events)
    @before_join_events = Array.new
    @after_join_events = Array.new
    @join_events.each do |event|
      #参加前のイベントを抽出（EventUserテーブルから検索）
      if event.finish_at > DateTime.now
        @before_join_events << event
      #参加済のイベントを抽出（EventUserテーブルから検索）
      else
        @after_join_events << event
      end
    end
    #ブックマークしたイベントを抽出
    @user_bookmarks = Bookmark.where(user_id: @user.id).pluck(:event_id).uniq
    @bookmark_events = Event.where(id: @user_bookmarks)
    #参加しているグループを抽出
    @user_groups = GroupUser.where(user_id: @user.id).pluck(:group_id).uniq
    @join_groups = Group.where(id: @user_groups)
    #参加申請中のグループを抽出
    @user_applies = Apply.where(user_id: @user.id).pluck(:group_id).uniq
    @apply_groups = Group.where(id: @user_applies)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = '登録情報を編集しました。'
      redirect_to user_path
    else
      render :edit
    end
  end

  #退会処理：ユーザーのis_validカラムをfalseに変更し、ログアウトさせる
  def leave
    @user = current_user
    @user.update(is_valid: false)
    deleted_email = @user.email + '_is_deleted' #退会するユーザーのメールアドレスに「_is_deleted」を付ける（再登録時のユニーク制約回避）
    @user.update(email: deleted_email)
    @user.skip_email_changed_notification! #deviseによるアドレス変更時の確認メールを送る処理をスキップ
    reset_session
    redirect_to root_path
  end

  def confirm
  end

  private

    def user_params
      params.require(:user).permit(:name, :introduction, :user_image)
    end

    #ログインしているユーザーと編集しようとしているユーザーが一致しないと編集画面に遷移できなくする
    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end
end
