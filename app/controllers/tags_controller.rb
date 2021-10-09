class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])  #クリックしたタグを取得
    @events = @tag.events.all           #クリックしたタグに紐付けられた投稿を全て表示
    @user = current_user #ユーザー情報表示用（サイドバー）
  end
end
