class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id]) #follow(params[:user_id]):Userモデル参照
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id]) #unfollow(params[:user_id]):Userモデル参照
    redirect_to request.referer
  end

  #フォローしている人一覧の表示用
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  #フォロワー一覧の表示用
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
