class Users::SessionsController < Devise::SessionsController
  before_action :reject_user, only: [:create]

  protected

  # 会員の論理削除のための記述。退会後は、同じメールアドレスではログイン不可とする。
  def reject_user
    @user = User.find_by(email: params[:user][:email].downcase)
    binding.pry
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false)
        flash[:error] = '退会済みです。再度ご登録をしてご利用ください。'
        redirect_to new_user_session_path
      else
        flash[:notice] = '項目を入力してください'
      end
    end
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
