class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_customer
    if @user.update(customer_params)
      flash[:notice] = '登録情報を編集しました。'
      redirect_to user_path
    else
      render :edit
    end
  end

  #退会処理：ユーザーのis_validカラムをfalseに変更し、ログアウトさせる
  def leave
    @user = current_customer
    @user.update(is_valid: false)
    reset_session
    redirect_to root_path
  end

  def confirm
  end
end
