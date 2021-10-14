class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  #CSRF対策
  protect_from_forgery with: :exception

  # ログイン後の画面遷移先指定
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  #ルーティングエラー（ActionController外）が出た場合の処理
  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  #例外処理

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from ActionController::RoutingError,   with: :render_404
  rescue_from Exception, with: :rescue500
  rescue_from Forbidden, with: :rescue403
  rescue_from IpAddressRejected, with: :rescue403

  private

    def error_404(exception)
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end

    def rescue404(e)
      @exception = e
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end

    def rescue500(e)
      @exception = e
      render file: Rails.root.join('public/500.html'), status: 404, layout: false, content_type: 'text/html'
    end

    def rescue403(e)
      @exception = e
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :is_valid])
    end
end
