class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id]) # models/user.rb参照：フォロー関係を生成
    @user = User.find(params[:user_id])
    @user.create_notification_follow!(current_user) # models/user.rb参照：フォローと同時に通知作成
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id]) # models/user.rb参照：フォロー関係を解消
    redirect_to request.referer
  end

  # フォローしている人一覧の表示用
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
    @user = current_user
  end

  # フォロワー一覧の表示用
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
    @user = current_user
  end
end
