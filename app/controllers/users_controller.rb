class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
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
    reset_session
    redirect_to root_path
  end

  def confirm
  end

  private

    def user_params
      params.require(:user).permit(:name, :introduction, :user_image)
    end
end