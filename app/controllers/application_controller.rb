class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後の画面遷移先指定
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  #例外処理：RecordNotFoundが生じた場合、404用のエラー画面を出し、エラーをログに出力する
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

  private

    def rescue404(e)
      @exception = e
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'

    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :is_valid])
    end
end
